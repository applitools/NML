/**
 * Maestro Runner + Appium + Eyes WDIO SDK + NML native capture.
 *
 * Usage:
 *   cp ../.env .env   # add your APPLITOOLS_API_KEY
 *   npm install
 *   appium &
 *   node run.mjs
 */

import dotenv from 'dotenv';
dotenv.config({ override: true });
import { Eyes } from '@applitools/eyes-webdriverio';
import { spawn } from 'child_process';
import {
  writeFileSync, unlinkSync, existsSync,
  readFileSync, mkdirSync,
} from 'fs';
import { join, dirname, resolve } from 'path';
import { fileURLToPath, pathToFileURL } from 'url';
import { homedir } from 'os';

const __dirname      = dirname(fileURLToPath(import.meta.url));
const CAPTURE_PORT   = 3456;
const MAESTRO_RUNNER = join(homedir(), '.maestro-runner', 'bin', 'maestro-runner');
const SESSION_FILE   = join(__dirname, '.maestro-session.json');

if (!existsSync(MAESTRO_RUNNER)) {
  console.error(`ERROR: maestro-runner not found at ${MAESTRO_RUNNER}`);
  process.exit(1);
}

if (!process.env.APPLITOOLS_API_KEY) {
  console.error('ERROR: APPLITOOLS_API_KEY is required');
  process.exit(1);
}

const { default: config } = await import(
  pathToFileURL(join(__dirname, 'applitools.config.js')).href
);

const nmlServerUrl =
  (process.env.APPLITOOLS_SERVER_URL || '').includes('eyesapi')
    ? process.env.APPLITOOLS_SERVER_URL
    : 'https://eyesapi.applitools.com';

// nml: true — inject NML library into caps via Eyes.setMobileCapabilities()
const capabilities = config.nml !== false
  ? Eyes.setMobileCapabilities(config.capabilities, {
      apiKey:    process.env.APPLITOOLS_API_KEY,
      serverUrl: nmlServerUrl,
    })
  : { ...config.capabilities };

const capsFile = join(__dirname, '.caps-tmp.json');
writeFileSync(capsFile, JSON.stringify(capabilities, null, 2));

const flowPath = process.argv[2]
  ? resolve(process.argv[2])
  : join(__dirname, 'flow.yaml');

if (!existsSync(flowPath)) {
  console.error(`ERROR: Flow not found: ${flowPath}`);
  process.exit(1);
}

const appiumUrl = process.env.APPIUM_URL || config.appiumUrl || 'http://localhost:4723/wd/hub';
const batchName = process.env.APPLITOOLS_BATCH_NAME || config.batchName || 'Maestro Eyes NML';
const appName   = process.env.APPLITOOLS_APP_NAME   || config.appName   || 'App';

console.log(`Appium : ${appiumUrl}`);
console.log(`Flow   : ${flowPath}`);
console.log(`Batch  : ${batchName}\n`);

const serverEnv = {
  ...process.env,
  APPLITOOLS_APP_NAME:   appName,
  APPLITOOLS_BATCH_NAME: batchName,
  APPLITOOLS_SERVER_URL: nmlServerUrl,
  APPLITOOLS_FULLY:     config.fully    !== false ? 'true' : 'false',
  APPLITOOLS_NML:       config.nml      !== false ? 'true' : 'false',
  APPLITOOLS_SEND_DOM:  config.sendDom  !== false ? 'true' : 'false',
  APPLITOOLS_USE_DOM:   config.useDom   !== false ? 'true' : 'false',
};

const captureServer = spawn('node', [join(__dirname, 'capture-server.mjs'), String(CAPTURE_PORT)], {
  env: serverEnv,
  stdio: ['ignore', 'pipe', 'pipe'],
});
captureServer.stdout.on('data', d => process.stdout.write(`[server] ${d}`));
captureServer.stderr.on('data', d => process.stderr.write(`[server] ${d}`));

async function serverHealth(retries = 20) {
  for (let i = 0; i < retries; i++) {
    try {
      const r = await fetch(`http://localhost:${CAPTURE_PORT}/health`);
      if (r.ok) return true;
    } catch { /* not ready yet */ }
    await new Promise(r => setTimeout(r, 1000));
  }
  return false;
}

if (!await serverHealth()) {
  console.error('Capture server failed to start');
  captureServer.kill();
  process.exit(1);
}
console.log('[server] Ready\n');

async function post(path, body) {
  const res = await fetch(`http://localhost:${CAPTURE_PORT}${path}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });
  return res.json();
}

async function pollSessionFile(timeoutMs = 90_000) {
  const deadline = Date.now() + timeoutMs;
  while (Date.now() < deadline) {
    if (existsSync(SESSION_FILE)) {
      try {
        const data = JSON.parse(readFileSync(SESSION_FILE, 'utf8'));
        const active = data.sessions?.find(s => s.status === 'active');
        if (active?.sessionId) return active;
      } catch { /* partial write — retry */ }
    }
    await new Promise(r => setTimeout(r, 500));
  }
  return null;
}

try { unlinkSync(SESSION_FILE); } catch { /* ignore */ }

const maestroArgs = [
  '--driver', 'appium',
  '--platform', 'ios',
  '--appium-url', appiumUrl,
  '--caps', capsFile,
  '--appium-session-file', SESSION_FILE,
  'test', flowPath,
];

let maestroExitCode = 0;
const maestroFinished = new Promise(resolveFinished => {
  const mr = spawn(MAESTRO_RUNNER, maestroArgs, { stdio: 'inherit', cwd: __dirname });
  mr.on('close', code => { maestroExitCode = code ?? 0; resolveFinished(); });
  mr.on('error', err => { console.error('maestro-runner error:', err.message); resolveFinished(); });
});

const session = await pollSessionFile();

if (!session) {
  console.warn('\nWARNING: Session ID not found — visual captures will be skipped');
} else {
  console.log(`\nSession ID: ${session.sessionId}`);
  const attachResult = await post('/attach', {
    sessionId: session.sessionId,
    appiumUrl: session.appiumUrl || appiumUrl,
    appName,
    testName:     process.env.APPLITOOLS_TEST_NAME || batchName,
    batch:        batchName,
    capabilities,
  });
  console.log(`Attach: ${attachResult.status || attachResult.error}\n`);
}

await maestroFinished;

console.log('\nClosing Applitools...');
const closeResult = await post('/close', {});
if (closeResult.url) {
  console.log(`\n✓ Results → ${closeResult.url}\n`);
}

captureServer.kill();
try { unlinkSync(capsFile); } catch { /* ignore */ }
try { unlinkSync(SESSION_FILE); } catch { /* ignore */ }

process.exit(maestroExitCode);
