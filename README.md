# typescript-wdio-appium-nml-ios-perfecto

TypeScript port of the plain-variant Perfecto iOS suite (WebdriverIO + Appium +
Applitools NML), sourced from `javascript-wdio-appium-nml-ios-perfecto`.

## Running the suite

```
npm test
```

## Notes on credentials

The `.env` file already contains a working `PERFECTO_CLOUD_NAME` and
`PERFECTO_SECURITY_TOKEN` pair (shared with the Android suites on this same
Perfecto account), plus a working `APPLITOOLS_API_KEY`.

However, `PERFECTO_APP_ANALYTICSX` and `PERFECTO_APP_ACCESSIBILITY` are only
placeholders — this Perfecto account does not yet have an iOS `.ipa` uploaded to its
media repository. Before running the suite, upload `AnalyticsXUIKit.ipa` and
`AccessibilityTestUIKit.ipa` to the Perfecto media repository and replace the
placeholder values with the returned `PERFECTO:REPOSITORY:...` paths.
