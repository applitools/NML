# java-appium-nml-android-local

Java Appium + Applitools NML — Android on a local Appium server / emulator (plain variant).

Ported from `java-android-nml-lambdatest_old` (LambdaTest reference implementation).

## Sample application (plug-and-play)

This branch does not commit the sample app binaries — download them from the
`main` branch's `static_instrumented_sample_application/` folder and place that
folder at the project root (same level as `package.json`/`pom.xml`):

    git clone --depth 1 --branch main https://github.com/applitools/NML.git nml-main
    cp -R nml-main/static_instrumented_sample_application ./static_instrumented_sample_application
    rm -rf nml-main

`static_instrumented_sample_application/android/` contains the `.apk` for each app
(AnalyticsX, Accessibility) — the same APK runs on both a real device and an emulator.

## Run

Start a local Appium server first (`appium`, listening on `http://127.0.0.1:4723`), have an Android emulator/device booted, then:

```
mvn compile exec:java
```

APPLITOOLS_API_KEY must be set as an environment variable before running. No cloud vendor credentials are required — the AnalyticsX and Accessibility APKs are bundled locally under `static_instrumented_sample_application/android/`. Optionally set AVD_NAME and PLATFORM_VERSION env vars to match your emulator (defaults: `Pixel_8_API_35` / `15.0`).
