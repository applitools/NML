/**
 * Maestro runScript bridge — POST to the local capture server to trigger
 * an Applitools NML visual checkpoint.
 *
 * Usage in YAML:
 *   - runScript:
 *       file: ./capture.js
 *       env:
 *         SCREENSHOT_NAME: My Screen Name
 */

var screenshotName = SCREENSHOT_NAME || 'checkpoint';

var response = http.post(
  'http://localhost:3456/capture/' + encodeURIComponent(screenshotName),
  {}
);

output.capture = {
  name: screenshotName,
  status: (response && response.status)
    ? response.status
    : (response && response.error ? 'error: ' + response.error : 'no-response'),
};
