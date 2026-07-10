# java-appium-nml-ios-multi-device-saucelabs

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

Runs `AnalyticsXIOSSauceLabsMultidevice_Test` by default. For `AccessibilityIOSSauceLabsMultidevice_Test`:

```
mvn compile exec:java -Dexec.mainClass=AccessibilityIOSSauceLabsMultidevice_Test
```
