# java-appium-nml-ios-perfecto

## Environment variables

- `APPLITOOLS_API_KEY`
- `PERFECTO_CLOUD_NAME`
- `PERFECTO_SECURITY_TOKEN`
- `FLOW`

## Run

```
mvn compile exec:java
```

Runs `AnalyticsXIOSPerfectoTest` by default. For `AccessibilityIOSPerfectoTest`:

```
mvn compile exec:java -Dexec.mainClass=AccessibilityIOSPerfectoTest
```
