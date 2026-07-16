## Native Mobile Library — Plug-and-Play

Branches are named by test vendor/environment, then language, framework, and platform:

```
<vendor>-plug-and-play/<language>-<framework>-<platform>[-multi-device]
```

### Boilerplate vs. Plug-and-Play

This repository holds the **plug-and-play** variants — vendor name suffixed with `-plug-and-play`, e.g. `browserstack-plug-and-play/javascript-wdio-appium-ios`. Add your credentials to `.env` (or as environment variables) and you're ready to go against the sample application already wired in.

The **boilerplate** variants (plain vendor name, e.g. `browserstack/javascript-wdio-appium-ios`) — starter templates with no application bundled, where you point `APP_ID` at your own app — live in a separate repo: **[applitools/nml-boilerplate](https://github.com/applitools/nml-boilerplate)**.

### Sample Applications

Sample applications (iOS Native and Android Native) are available in the **main** branch:

- `static_instrumented_sample_application/` — ready to use as-is. These apps are already statically instrumented with the Applitools SDK, so no extra setup is needed.
- `SampleApplication/Applitcation1-accessibility-app` and `SampleApplication/Application2-analyticsx-app` — Accessibility and AnalyticsX sample apps (iOS Native, Android Native) that must be dynamically instrumented before use. See the [iOS](https://applitools.com/docs/eyes/concepts/best-practices/native-mobile-library#ios_dynamic) and [Android](https://applitools.com/docs/eyes/concepts/best-practices/native-mobile-library#android_dynamic) dynamic instrumentation guides.

### Java Appium — iOS

  local-plug-and-play/java-appium-ios

  local-plug-and-play/java-appium-ios-multi-device

  lambdatest-plug-and-play/java-appium-ios

  lambdatest-plug-and-play/java-appium-ios-multi-device

  perfecto-plug-and-play/java-appium-ios

  perfecto-plug-and-play/java-appium-ios-multi-device

  saucelabs-plug-and-play/java-appium-ios

  saucelabs-plug-and-play/java-appium-ios-multi-device

  browserstack-plug-and-play/java-appium-ios

  browserstack-plug-and-play/java-appium-ios-multi-device

### Java Appium — Android

  local-plug-and-play/java-appium-android

  local-plug-and-play/java-appium-android-multi-device

  lambdatest-plug-and-play/java-appium-android

  lambdatest-plug-and-play/java-appium-android-multi-device

  perfecto-plug-and-play/java-appium-android

  perfecto-plug-and-play/java-appium-android-multi-device

  saucelabs-plug-and-play/java-appium-android

  saucelabs-plug-and-play/java-appium-android-multi-device

  browserstack-plug-and-play/java-appium-android

  browserstack-plug-and-play/java-appium-android-multi-device

### JavaScript WDIO Appium — iOS

  local-plug-and-play/javascript-wdio-appium-ios

  local-plug-and-play/javascript-wdio-appium-ios-multi-device

  lambdatest-plug-and-play/javascript-wdio-appium-ios

  lambdatest-plug-and-play/javascript-wdio-appium-ios-multi-device

  perfecto-plug-and-play/javascript-wdio-appium-ios

  perfecto-plug-and-play/javascript-wdio-appium-ios-multi-device

  saucelabs-plug-and-play/javascript-wdio-appium-ios

  saucelabs-plug-and-play/javascript-wdio-appium-ios-multi-device

  browserstack-plug-and-play/javascript-wdio-appium-ios

  browserstack-plug-and-play/javascript-wdio-appium-ios-multi-device

### JavaScript WDIO Appium — Android

  local-plug-and-play/javascript-wdio-appium-android

  local-plug-and-play/javascript-wdio-appium-android-multi-device

  lambdatest-plug-and-play/javascript-wdio-appium-android

  lambdatest-plug-and-play/javascript-wdio-appium-android-multi-device

  perfecto-plug-and-play/javascript-wdio-appium-android

  perfecto-plug-and-play/javascript-wdio-appium-android-multi-device

  saucelabs-plug-and-play/javascript-wdio-appium-android

  saucelabs-plug-and-play/javascript-wdio-appium-android-multi-device

  browserstack-plug-and-play/javascript-wdio-appium-android

  browserstack-plug-and-play/javascript-wdio-appium-android-multi-device

### TypeScript WDIO Appium — iOS

  local-plug-and-play/typescript-wdio-appium-ios

  local-plug-and-play/typescript-wdio-appium-ios-multi-device

  lambdatest-plug-and-play/typescript-wdio-appium-ios

  lambdatest-plug-and-play/typescript-wdio-appium-ios-multi-device

  perfecto-plug-and-play/typescript-wdio-appium-ios

  perfecto-plug-and-play/typescript-wdio-appium-ios-multi-device

  saucelabs-plug-and-play/typescript-wdio-appium-ios

  saucelabs-plug-and-play/typescript-wdio-appium-ios-multi-device

  browserstack-plug-and-play/typescript-wdio-appium-ios

  browserstack-plug-and-play/typescript-wdio-appium-ios-multi-device

### TypeScript WDIO Appium — Android

  local-plug-and-play/typescript-wdio-appium-android

  local-plug-and-play/typescript-wdio-appium-android-multi-device

  lambdatest-plug-and-play/typescript-wdio-appium-android

  lambdatest-plug-and-play/typescript-wdio-appium-android-multi-device

  perfecto-plug-and-play/typescript-wdio-appium-android

  perfecto-plug-and-play/typescript-wdio-appium-android-multi-device

  saucelabs-plug-and-play/typescript-wdio-appium-android

  saucelabs-plug-and-play/typescript-wdio-appium-android-multi-device

  browserstack-plug-and-play/typescript-wdio-appium-android

  browserstack-plug-and-play/typescript-wdio-appium-android-multi-device

### Maestro

Maestro does not support direct Eyes SDK integration or Appium, so its NML support is a workaround built on the Maestro runner rather than a native integration like the suites above. See `maestro-local/ios-nml-workaround` in [applitools/nml-boilerplate](https://github.com/applitools/nml-boilerplate).
