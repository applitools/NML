# java-appium-nml-android-multi-device

## Environment variables

- `APPLITOOLS_API_KEY`
- `AVD_NAME`
- `PLATFORM_VERSION`

## Sample application

This branch does not commit the sample app binaries. Download them from `main`:

```
git clone --depth 1 --branch main https://github.com/applitools/NML.git nml-main
cp -R nml-main/static_instrumented_sample_application ./static_instrumented_sample_application
rm -rf nml-main
```

## Run

Start a local Appium server first (`appium`), then:

```
mvn compile exec:java
```

Runs `AnalyticsXAndroidLocalMultidevice_Test` by default. For `AccessibilityAndroidLocalMultidevice_Test`:

```
mvn compile exec:java -Dexec.mainClass=AccessibilityAndroidLocalMultidevice_Test
```
