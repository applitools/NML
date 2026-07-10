# java-appium-nml-android-multi-device-perfecto

Java Appium + Applitools NML — Android on Perfecto (multi-device variant).

Ported from `java-android-nml-lambdatest_old` (LambdaTest reference implementation).

## Run

```
mvn compile exec:java
```

APPLITOOLS_API_KEY, PERFECTO_CLOUD_NAME, and PERFECTO_SECURITY_TOKEN must be set as environment variables before running. The AnalyticsX app id (`PUBLIC:AnalyticsX_XMLLayout.apk`) is a real, already-published Perfecto repository entry; the Accessibility app id is a placeholder (`PERFECTO:REPOSITORY:PASTE_ACCESSIBILITY_APK_HERE`) — upload the Accessibility APK to the Perfecto repository and replace it.
