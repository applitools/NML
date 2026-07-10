// Appium + Applitools configuration — Eyes WDIO SDK + NML native capture.
// Run with: node run.mjs

export default {
  // ── Appium ─────────────────────────────────────────────────────────────────
  appiumUrl: process.env.APPIUM_URL,

  capabilities: {
    platformName: 'iOS',
    'appium:automationName': 'XCUITest',
    'appium:app':             process.env.APP_PATH,
    'appium:deviceName':      process.env.DEVICE_NAME,
    'appium:udid':            process.env.DEVICE_UDID,
    'appium:platformVersion': process.env.PLATFORM_VERSION,
    'appium:orientation':     'PORTRAIT',
    'appium:newCommandTimeout': 300,
    'appium:noReset': false,
    'appium:autoAcceptAlerts': true,
    'appium:autoLaunch': true,   // required: ensures processArguments (DYLD_INSERT_LIBRARIES) applies
  },

  // ── Applitools ─────────────────────────────────────────────────────────────
  appName:   'AnalyticsX',
  batchName: process.env.APPLITOOLS_BATCH_NAME || 'AnalyticsX — Maestro + NML',

  matchLevel: 'Strict',
  fully:    true,  // full-page NML scroll-stitch
  nml:      true,  // use NML native capture
  sendDom:  true,  // send native element hierarchy to Applitools
  useDom:   true,  // use element hierarchy in visual matching
};
