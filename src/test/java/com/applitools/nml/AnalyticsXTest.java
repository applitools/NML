package com.applitools.nml;

import com.applitools.eyes.appium.Eyes;
import io.appium.java_client.AppiumBy;
import io.appium.java_client.ios.IOSDriver;
import org.openqa.selenium.WebElement;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

public class AnalyticsXTest extends BaseTest {

    private static final String APP_PATH  = env("ANALYTICSX_APP_PATH",
            "SampleApplication/Application2-analyticsx-app/IOS Native/UIKit/Emulator/AnalyticsXUIKit-Simulator.app");
    private static final String BUNDLE_ID = env("ANALYTICSX_BUNDLE_ID", "com.applitools.AnalyticsXUIKit");

    private IOSDriver driver;
    private Eyes eyes;

    @BeforeMethod
    public void setUp() throws Exception {
        driver = createDriver(APP_PATH, BUNDLE_ID);
        eyes   = createEyes();
    }

    @AfterMethod
    public void tearDown() {
        if (eyes   != null) eyes.abortIfNotClosed();
        if (driver != null) driver.quit();
    }

    @Test
    public void loginFlow() throws Exception {
        Thread.sleep(2000);
        eyes.open(driver, EYES_APP_NAME, "AnalyticsX - Login");
        eyes.checkWindow("Login Screen");

        WebElement loginButton = driver.findElement(AppiumBy.accessibilityId("Login"));
        loginButton.click();
        Thread.sleep(2000);

        eyes.checkWindow("Post Login");
        eyes.close();
    }
}
