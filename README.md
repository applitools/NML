# java-appium-nml-ios-saucelabs

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

Runs `AnalyticsXIOSSauceLabsTest` by default. For `AccessibilityIOSSauceLabsTest`:

```
mvn compile exec:java -Dexec.mainClass=AccessibilityIOSSauceLabsTest
```
