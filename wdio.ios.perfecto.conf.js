import dotenv from 'dotenv';
import { Eyes } from '@applitools/eyes-webdriverio';

// override: true — a stale shell-exported var (e.g. an old PERFECTO_SECURITY_TOKEN)
// would otherwise silently win over .env, since dotenv only fills in unset vars by default.
dotenv.config({ override: true });

// Resolve which app is under test from ACTIVE_APP, and derive its url/specs from that
const APPS = {
  analyticsx: {
    appUrl: process.env.PERFECTO_APP_ANALYTICSX,
    specs: ['./test/specs/ios/analyticsX.ios.test.js'],
  },
  accessibility: {
    appUrl: process.env.PERFECTO_APP_ACCESSIBILITY,
    specs: ['./test/specs/ios/accessibility.ios.test.js'],
  },
};

const activeAppName = process.env.ACTIVE_APP?.trim().toLowerCase();
const activeApp = APPS[activeAppName];
if (!activeApp) {
  throw new Error(
    `ACTIVE_APP "${process.env.ACTIVE_APP}" must be one of: ${Object.keys(APPS).join(', ')}`
  );
}

// Step 1: Eyes.setMobileCapabilities injects appium:processArguments (iOS NML config)
const caps = Eyes.setMobileCapabilities({
  platformName: 'iOS',
  'appium:app': activeApp.appUrl,
  'appium:deviceName': process.env.DEVICE_NAME,
  'appium:platformVersion': process.env.PLATFORM_VERSION,
  'appium:automationName': 'XCUITest',
  'appium:noReset': false,
  'appium:newCommandTimeout': 300,
}, process.env.APPLITOOLS_API_KEY);


// Step 3: Attach perfecto:options
caps['perfecto:options'] = {
  securityToken: process.env.PERFECTO_SECURITY_TOKEN,
};

const cloudName = process.env.PERFECTO_CLOUD_NAME;

export const config = {

  // Auto-selected based on ACTIVE_APP — see the APPS lookup above
  specs: activeApp.specs,

  maxInstances: 1,

  hostname: `${cloudName}.perfectomobile.com`,
  port: 443,
  protocol: 'https',
  path: '/nexperience/perfectomobile/wd/hub',

  capabilities: [caps],

  logLevel: 'info',

  waitforTimeout: 10000,
  connectionRetryTimeout: 120000,
  connectionRetryCount: 3,

  services: [],

  framework: 'mocha',

  mochaOpts: {
    timeout: 300000,
  },

  reporters: ['spec'],

  afterTest: async function (test, context, { error }) {
    const status = error ? 'FAILED' : 'PASSED';
    await browser.execute(`perfectomobile:status=${status}`);
  },
};
