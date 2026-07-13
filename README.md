## Native Mobile Library

Branches are named by test vendor/environment, then language, framework, and platform:

```
<vendor-or-local>[-plug-and-play]/<language>-<framework>-<platform>[-multi-device]
```

### Boilerplate vs. Plug-and-Play

Every combination below comes in two variants:

- **Boilerplate** (plain vendor name, e.g. `browserstack/javascript-wdio-appium-ios`) — a starter template with no application bundled. Add your credentials and point `APP_ID` (and, for Android, `APP_PACKAGE`/`APP_ACTIVITY`) at your own app, then adapt the test to your own screens.
- **Plug-and-play** (`-plug-and-play` suffix on the vendor, e.g. `browserstack-plug-and-play/javascript-wdio-appium-ios`) — add your credentials to `.env` (or as environment variables) and you're ready to go against the sample application already wired in.

> **Exception:** `lambdatest/java-appium-ios`, `lambdatest/java-appium-ios-multi-device`, `lambdatest/java-appium-android`, and `lambdatest/java-appium-android-multi-device` don't exist yet — only their `lambdatest-plug-and-play/...` counterparts do; the boilerplate variant hasn't been built for these four.

### Sample Applications

Sample applications (iOS Native and Android Native) are available in the **main** branch:

- `static_instrumented_sample_application/` — ready to use as-is. These apps are already statically instrumented with the Applitools SDK, so no extra setup is needed.
- `SampleApplication/Applitcation1-accessibility-app` and `SampleApplication/Application2-analyticsx-app` — Accessibility and AnalyticsX sample apps (iOS Native, Android Native) that must be dynamically instrumented before use. See the [iOS](https://applitools.com/docs/eyes/concepts/best-practices/native-mobile-library#ios_dynamic) and [Android](https://applitools.com/docs/eyes/concepts/best-practices/native-mobile-library#android_dynamic) dynamic instrumentation guides.

### Java Appium — iOS

  local/java-appium-ios

  local/java-appium-ios-multi-device

  lambdatest/java-appium-ios

  lambdatest/java-appium-ios-multi-device

  perfecto/java-appium-ios

  perfecto/java-appium-ios-multi-device

  saucelabs/java-appium-ios

  saucelabs/java-appium-ios-multi-device

  browserstack/java-appium-ios

  browserstack/java-appium-ios-multi-device

### Java Appium — Android

  local/java-appium-android

  local/java-appium-android-multi-device

  lambdatest/java-appium-android

  lambdatest/java-appium-android-multi-device

  perfecto/java-appium-android

  perfecto/java-appium-android-multi-device

  saucelabs/java-appium-android

  saucelabs/java-appium-android-multi-device

  browserstack/java-appium-android

  browserstack/java-appium-android-multi-device

### JavaScript WDIO Appium — iOS

  local/javascript-wdio-appium-ios

  local/javascript-wdio-appium-ios-multi-device

  lambdatest/javascript-wdio-appium-ios

  lambdatest/javascript-wdio-appium-ios-multi-device

  perfecto/javascript-wdio-appium-ios

  perfecto/javascript-wdio-appium-ios-multi-device

  saucelabs/javascript-wdio-appium-ios

  saucelabs/javascript-wdio-appium-ios-multi-device

  browserstack/javascript-wdio-appium-ios

  browserstack/javascript-wdio-appium-ios-multi-device

### JavaScript WDIO Appium — Android

  local/javascript-wdio-appium-android

  local/javascript-wdio-appium-android-multi-device

  lambdatest/javascript-wdio-appium-android

  lambdatest/javascript-wdio-appium-android-multi-device

  perfecto/javascript-wdio-appium-android

  perfecto/javascript-wdio-appium-android-multi-device

  saucelabs/javascript-wdio-appium-android

  saucelabs/javascript-wdio-appium-android-multi-device

### TypeScript WDIO Appium — iOS

  local/typescript-wdio-appium-ios

  local/typescript-wdio-appium-ios-multi-device

  lambdatest/typescript-wdio-appium-ios

  lambdatest/typescript-wdio-appium-ios-multi-device

  perfecto/typescript-wdio-appium-ios

  perfecto/typescript-wdio-appium-ios-multi-device

  saucelabs/typescript-wdio-appium-ios

  saucelabs/typescript-wdio-appium-ios-multi-device

  browserstack/typescript-wdio-appium-ios

  browserstack/typescript-wdio-appium-ios-multi-device

### TypeScript WDIO Appium — Android

  local/typescript-wdio-appium-android

  local/typescript-wdio-appium-android-multi-device

  lambdatest/typescript-wdio-appium-android

  lambdatest/typescript-wdio-appium-android-multi-device

  perfecto/typescript-wdio-appium-android

  perfecto/typescript-wdio-appium-android-multi-device

  saucelabs/typescript-wdio-appium-android

  saucelabs/typescript-wdio-appium-android-multi-device

### Maestro

Maestro does not support direct Eyes SDK integration or Appium, so its NML support is a workaround built on the Maestro runner rather than a native integration like the suites above.
