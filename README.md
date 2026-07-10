# java-appium-nml-ios-multi-device-lambdatest

Java Appium + Applitools NML — iOS on LambdaTest (multi-device variant).

## Test classes

- `AccessibilityIOSLambda_NML_Multidevice_Test`
- `AnalyticsXIOSLambda_NML_Multidevice_Test`

## Required environment variables

- `APPLITOOLS_API_KEY` — Applitools API key
- `LT_USERNAME` — LambdaTest username
- `LT_ACCESS_KEY` — LambdaTest access key
- `APP_ID` — optional; overrides the default `lt://` app URL hardcoded in each test class

## Run

```
mvn compile exec:java
```

Runs `AnalyticsXIOSLambda_NML_Multidevice_Test` by default. To run the other test class:

```
mvn compile exec:java -Dexec.mainClass=AccessibilityIOSLambda_NML_Multidevice_Test
```
