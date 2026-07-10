# Maestro + Applitools Eyes SDK/NML — Working Workaround

Working workaround for when a customer wants to use Maestro with Applitools Eyes SDK/NML.

→ Statically instrument or dynamically instrument the application.

→ Maestro Runner passes `DYLD_INSERT_LIBRARIES` through `appium:processArguments` during Appium session creation, which allows the Eyes SDK to utilise NML. You can then verify if the application is NML instrumented — it reports `instrumented: true` in `eyes.log` when instrumentation is active.

→ Once the Appium session is created, we extract the session ID from the generated reports/logs and use WebdriverIO's `attach()` API to connect to the existing Appium session.

→ The Eyes WebdriverIO SDK then runs against that shared Appium session and captures visual checkpoints using the existing Eyes SDK workflow:

1. `run.mjs` starts — spins up `capture-server.mjs` (port 3456) as a background process, then launches `maestro-runner` with `flow.yaml`.
2. Appium creates a session — `maestro-runner` connects to Appium, Appium assigns a session ID (UUID).
3. `run.mjs` grabs the session ID — from `.maestro-session.json` (v1.1.17+).
4. `run.mjs` POSTs `/attach` to the capture server with that session ID — the capture server uses it to hook into the already-running Appium session via `webdriverio.attach()`.
5. `flow.yaml` runs — whenever it hits a `runScript: capture.js` step, `capture.js` POSTs to `http://localhost:3456/capture/<name>`.
6. Capture server receives the request — opens Eyes on the first capture, then calls `eyes.check()` for every capture after that.
7. `flow.yaml` finishes — `run.mjs` POSTs `/close` to the capture server, which calls `eyes.close()` and returns the dashboard URL.
8. Cleanup — capture server is killed, temp files deleted, process exits.

> The app must be statically instrumented with `Applitools_iOS.framework`. NML (Native Mobile Library) captures iOS apps at the native rendering level — full-page scroll-stitching, element-level diffs, and far fewer false positives than pixel comparison.

## Prerequisites

- `maestro-runner` v1.1.17+ installed
  ```bash
  curl -fsSL https://open.devicelab.dev/install/maestro-runner | bash
  ```
- Appium running locally
  ```bash
  appium &
  ```
- iPhone 15 Pro — NML simulator booted with the app installed
- Applitools API key

## Setup (once)

```bash
cp .env.example .env   # fill in APPLITOOLS_API_KEY and device/app details
npm install
```

## Run

```bash
node run.mjs
```

Or:
```bash
npm test
```

## Files

| File | Purpose |
|------|---------|
| `flow.yaml` | Maestro flow — uses `runScript: ./capture.js` at each checkpoint. No `launchApp` — maestro-runner launches the app with NML already injected |
| `capture.js` | Runs inside Maestro — calls the local capture server via HTTP |
| `capture-server.mjs` | Local HTTP server that holds the Eyes session and triggers NML checks |
| `run.mjs` | Orchestrator — injects NML caps, attaches WDIO, closes Eyes |
| `applitools.config.js` | Edit this — device UDID, app path, Applitools settings (`nml: true`, `sendDom: true`, `useDom: true`) |
| `package.json` | Dependencies: `@applitools/eyes-webdriverio`, `webdriverio`, `dotenv` |
| `.env.example` | Copy to `.env` and fill in your `APPLITOOLS_API_KEY` and device/app config |

## NML vs plain Eyes SDK

| | Eyes SDK | Eyes SDK + NML |
|--|---------|----------------|
| Screenshot method | Appium screenshot | Native rendering capture |
| Full-page stitching | No | Yes |
| Element-level diffs | No | Yes |
| App instrumentation needed | No | Yes |
