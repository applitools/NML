package com.applitools.nml;

import com.applitools.eyes.appium.Eyes;
import io.appium.java_client.ios.IOSDriver;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import java.util.List;
import java.util.Map;

public class AccessibilityTest extends BaseTest {

    private static final String APP_PATH  = env("ACCESSIBILITY_APP_PATH",
            "SampleApplication/Applitcation1-accessibility-app/IOS Native/UI Kit/Simulator/AccessibilityTestUIKit.app");
    private static final String BUNDLE_ID = env("ACCESSIBILITY_BUNDLE_ID", "com.applitools.AccessibilityTestUIKit");

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

    private void launchWithFontSize(String contentSizeCategory) throws Exception {
        driver.executeScript("mobile: terminateApp", Map.of("bundleId", BUNDLE_ID));
        driver.executeScript("mobile: launchApp", Map.of(
                "bundleId",  BUNDLE_ID,
                "arguments", List.of("-UIPreferredContentSizeCategoryName", contentSizeCategory)
        ));
        Thread.sleep(2000);
    }

    @Test
    public void normalFontSize() throws Exception {
        launchWithFontSize("UICTContentSizeCategoryL");
        eyes.open(driver, EYES_APP_NAME, "Accessibility - Normal Font Size");
        eyes.checkWindow("Normal Font");
        eyes.close();
    }

    @Test
    public void largeFontSize() throws Exception {
        launchWithFontSize("UICTContentSizeCategoryAccessibilityXXXL");
        eyes.open(driver, EYES_APP_NAME, "Accessibility - Large Font Size");
        eyes.checkWindow("Large Font");
        eyes.close();
    }
}
