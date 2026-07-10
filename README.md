# java-appium-nml-android-multi-device-saucelabs

## Environment variables

- `APPLITOOLS_API_KEY`
- `SAUCE_USERNAME`
- `SAUCE_ACCESS_KEY`
- `SAUCE_REGION`
- `FLOW`

## Run

```
mvn compile exec:java
```

Runs `AnalyticsXAndroidSauceLabsMultidevice_Test` by default. For `AccessibilityAndroidSauceLabsMultidevice_Test`:

```
mvn compile exec:java -Dexec.mainClass=AccessibilityAndroidSauceLabsMultidevice_Test
```
