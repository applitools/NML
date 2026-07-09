# java-appium-nml-android-multi-device-lambdatest

Java Appium + Applitools NML — Android on LambdaTest (multi-device variant).

## Test classes

- `AccessibilityAndroidLambda_NMLMultidevice_Test`
- `AnalyticsXAndroidLambda_NMLMultidevice_Test`

## Required environment variables

- `APPLITOOLS_API_KEY` — Applitools API key
- `LT_USERNAME` — LambdaTest username
- `LT_ACCESS_TOKEN` — LambdaTest access key
- `APP_ID` — optional; overrides the default `lt://` app URL hardcoded in each test class

## Run

```
mvn compile exec:java
```

Runs `AnalyticsXAndroidLambda_NMLMultidevice_Test` by default. To run the other test class:

```
mvn compile exec:java -Dexec.mainClass=AccessibilityAndroidLambda_NMLMultidevice_Test
```
