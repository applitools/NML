# java-appium-nml-ios-lambdatest

Java Appium + Applitools NML — iOS on LambdaTest.

## Test classes

- `AccessibilityIOSLambdaTest`
- `AnalyticsXIOSLambdaTest`

## Required environment variables

- `APPLITOOLS_API_KEY` — Applitools API key
- `LT_USERNAME` — LambdaTest username
- `LT_ACCESS_KEY` — LambdaTest access key
- `APP_ID` — optional; overrides the default `lt://` app URL hardcoded in each test class

## Run

```
mvn compile exec:java
```

Runs `AnalyticsXIOSLambdaTest` by default. To run the other test class:

```
mvn compile exec:java -Dexec.mainClass=AccessibilityIOSLambdaTest
```
