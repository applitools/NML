# java-appium-nml-ios-multi-device-perfecto

## Environment variables

- `APPLITOOLS_API_KEY`
- `PERFECTO_CLOUD_NAME`
- `PERFECTO_SECURITY_TOKEN`
- `FLOW`

## Run

```
mvn compile exec:java
```

Runs `AnalyticsXIOSPerfectoMultidevice_Test` by default. For `AccessibilityIOSPerfectoMultidevice_Test`:

```
mvn compile exec:java -Dexec.mainClass=AccessibilityIOSPerfectoMultidevice_Test
```
