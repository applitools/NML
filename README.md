# java-appium-nml-android-saucelabs

Java Appium + Applitools NML — Android on Sauce Labs (plain variant).

Ported from `java-android-nml-lambdatest_old` (LambdaTest reference implementation).

## Run

```
mvn compile exec:java
```

APPLITOOLS_API_KEY, SAUCE_USERNAME, SAUCE_ACCESS_KEY, and SAUCE_REGION (optional, default us-west-1) must be set as environment variables before running. The AnalyticsX app id is a placeholder (`storage:filename=AnalyticsX_XMLLayout.apk`) that needs a real AnalyticsX APK uploaded to Sauce Labs app storage.
