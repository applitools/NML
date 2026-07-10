# java-appium-nml-android-browserstack

## Environment variables

- `APPLITOOLS_API_KEY`
- `BROWSERSTACK_USERNAME`
- `BROWSERSTACK_ACCESS_KEY`

## Run

```
mvn compile exec:java
```

Runs `AnalyticsXAndroidBrowserStackTest` by default. For `AccessibilityAndroidBrowserStackTest`:

```
mvn compile exec:java -Dexec.mainClass=AccessibilityAndroidBrowserStackTest
```

## Upload application to BrowserStack

```
curl -u "$BROWSERSTACK_USERNAME:$BROWSERSTACK_ACCESS_KEY" \
  -X POST "https://api-cloud.browserstack.com/app-automate/upload" \
  -F "file=@/path/to/YourApp.apk"
```

Response: `{"app_url":"bs://<app_id>"}`
