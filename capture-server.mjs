/**
 * HTTP capture server — receives visual checkpoint requests from Maestro runScript
 * and triggers Eyes checks via an attached WebdriverIO session.
 *
 * Endpoints:
 *   GET  /health            → { status: 'ok', attached: bool }
 *   POST /attach            → attach WDIO to existing Appium session + configure Eyes
 *   POST /capture/:name     → eyes.check(name, Target.window().fully())
 *   POST /close             → eyes.close() + return results URL
 */

import dotenv from 'dotenv';
dotenv.config({ override: true }); // .env takes priority over shell env vars
import http from 'http';
import { mkdirSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
import { attach } from 'webdriverio';
import {
  Eyes, Target, Configuration, BatchInfo, FileLogHandler,
} from '@applitools/eyes-webdriverio';

const PORT = parseInt(process.argv[2] || '3456', 10);
const __dirname = dirname(fileURLToPath(import.meta.url));
const e = process.env;

// ── State ─────────────────────────────────────────────────────────────────────

let browser = null;
let eyes = null;
let currentConfig = null;
let currentAppName = e.APPLITOOLS_APP_NAME || 'App';
let currentTestName = '';
let isAttached = false;
let isEyesOpen = false;

// ── Helpers ───────────────────────────────────────────────────────────────────

function parseBody(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', c => { body += c; });
    req.on('end', () => {
      try { resolve(body ? JSON.parse(body) : {}); } catch (err) { reject(err); }
    });
    req.on('error', reject);
  });
}

function json(res, status, data) {
  res.writeHead(status, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify(data));
}

// ── Handlers ──────────────────────────────────────────────────────────────────

async function handleAttach(req, res) {
  const body = await parseBody(req);
  const { sessionId, appiumUrl, appName, testName, batch, capabilities } = body;

  if (!sessionId || !appiumUrl) {
    json(res, 400, { error: 'sessionId and appiumUrl are required' });
    return;
  }

  const url = new URL(appiumUrl);
  browser = await attach({
    sessionId,
    protocol: url.protocol.replace(':', ''),
    hostname: url.hostname,
    port: parseInt(url.port || '4723', 10),
    path: url.pathname,
    capabilities: capabilities ?? { platformName: 'iOS', 'appium:automationName': 'XCUITest' },
  });

  const config = new Configuration();
  config.setApiKey(e.APPLITOOLS_API_KEY);
  config.setServerUrl(e.APPLITOOLS_SERVER_URL || 'https://eyesapi.applitools.com');

  const batchName = e.APPLITOOLS_BATCH_NAME || batch || 'Maestro NML';
  config.setBatch(new BatchInfo({ name: batchName }));

  if (e.APPLITOOLS_FULLY !== 'false') config.setFully(true);

  // Send and use native DOM tree (NML element hierarchy) for visual matching.
  // Sourced from sdk-master/js/packages/eyes/src/input/Configuration.ts
  config.setSendDom(e.APPLITOOLS_SEND_DOM !== 'false');
  config.setUseDom(e.APPLITOOLS_USE_DOM !== 'false');

  eyes = new Eyes();

  const logsDir = join(__dirname, 'applitools-logs');
  mkdirSync(logsDir, { recursive: true });
  const ts = new Date().toISOString().replace(/[:.]/g, '-');
  eyes.setLogHandler(new FileLogHandler(true, join(logsDir, `eyes-${ts}.log`), true));
  console.log(`  Logs → ${join(logsDir, `eyes-${ts}.log`)}`);

  if (appName) currentAppName = appName;
  currentTestName = testName || batchName;
  currentConfig = config;
  isAttached = true;

  console.log(`  Attached to session ${sessionId} (sendDom=${e.APPLITOOLS_SEND_DOM !== 'false'}, useDom=${e.APPLITOOLS_USE_DOM !== 'false'})`);
  json(res, 200, { status: 'attached', sessionId });
}

async function openEyes() {
  if (!browser || !eyes || !currentConfig || isEyesOpen) return;
  eyes.setConfiguration(currentConfig);
  await eyes.open(browser, currentAppName, currentTestName);
  isEyesOpen = true;
  console.log(`  Eyes opened — ${currentAppName} / ${currentTestName}`);
}

// Wait up to 30 s for /attach — handles the race where the first runScript
// fires before pollForSessionId has returned and attached WDIO.
async function waitForAttach(timeoutMs = 30_000) {
  const deadline = Date.now() + timeoutMs;
  while (!isAttached && Date.now() < deadline) {
    await new Promise(r => setTimeout(r, 500));
  }
  return isAttached;
}

async function handleCapture(req, res, name) {
  if (!isAttached && !(await waitForAttach())) {
    json(res, 400, { error: 'Timed out waiting for /attach' });
    return;
  }

  if (!isEyesOpen) await openEyes();

  const opts = await parseBody(req);
  const fully = opts.fully !== false && e.APPLITOOLS_FULLY !== 'false';
  const nml   = opts.nml   !== false && e.APPLITOOLS_NML   !== 'false';

  let target = Target.window();
  if (fully) target = target.fully();
  if (!nml)  target = target.disableBrowserFetching();

  console.log(`  Capturing: ${name} (fully=${fully}, nml=${nml})`);
  await eyes.check(name, target);
  json(res, 200, { status: 'captured', name });
}

async function handleClose(res) {
  let url = '';
  if (eyes && isEyesOpen) {
    try {
      const results = await eyes.close(false);
      url = results?.getUrl?.() || '';
    } catch {
      await eyes.abort().catch(() => {});
    }
  } else if (eyes) {
    await eyes.abort().catch(() => {});
  }

  browser         = null;
  eyes            = null;
  currentConfig   = null;
  currentAppName  = e.APPLITOOLS_APP_NAME || 'App';
  currentTestName = '';
  isAttached      = false;
  isEyesOpen      = false;

  console.log('  Session closed', url ? `→ ${url}` : '');
  json(res, 200, { status: 'closed', url });
}

// ── Server ────────────────────────────────────────────────────────────────────

const server = http.createServer(async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  if (req.method === 'OPTIONS') { res.writeHead(200); res.end(); return; }

  const { pathname } = new URL(req.url || '/', `http://localhost:${PORT}`);

  try {
    if (pathname === '/health') {
      json(res, 200, { status: 'ok', attached: isAttached });
    } else if (pathname === '/attach' && req.method === 'POST') {
      await handleAttach(req, res);
    } else if (pathname.startsWith('/capture/') && req.method === 'POST') {
      await handleCapture(req, res, decodeURIComponent(pathname.slice('/capture/'.length)));
    } else if (pathname === '/close' && req.method === 'POST') {
      await handleClose(res);
    } else {
      json(res, 404, { error: 'Not found' });
    }
  } catch (err) {
    console.error('  Error:', err.message);
    json(res, 500, { error: err.message });
  }
});

server.listen(PORT, () => console.log(`  Capture server :${PORT}`));

async function shutdown() {
  if (eyes) await eyes.abort().catch(() => {});
  server.close();
  process.exit(0);
}
process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
