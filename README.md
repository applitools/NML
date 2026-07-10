# java-appium-nml-android-saucelabs

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

Runs `AnalyticsXAndroidSauceLabsTest` by default. For `AccessibilityAndroidSauceLabsTest`:

```
mvn compile exec:java -Dexec.mainClass=AccessibilityAndroidSauceLabsTest
```
