import com.applitools.eyes.BatchInfo;
import com.applitools.eyes.appium.Eyes;
import com.applitools.eyes.appium.Target;

import com.applitools.eyes.config.Configuration;
import io.appium.java_client.ios.IOSDriver;

import org.openqa.selenium.remote.DesiredCapabilities;

import java.net.URL;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;

/**
 * iOS Accessibility App — Applitools NML + Perfecto Real Device
 *
 * ENV VARS:
 *   APPLITOOLS_API_KEY   — Applitools API key
 *   PERFECTO_CLOUD_NAME  — Perfecto cloud name
 *   PERFECTO_SECURITY_TOKEN — Perfecto security token
 * APP:
 *   Application1 — Accessibility app (SwiftUI real device IPA)
 *   Upload the IPA to your Perfecto repository and replace the hardcoded
 *   value in APP_ID below with the returned PERFECTO:REPOSITORY:... reference.
 */
public class AccessibilityIOSPerfectoTest {

    // ── App ID ──────────────────────────────────────────────────────────────
    // TODO: upload AccessibilityTestUIKit.ipa to the Perfecto repository and paste the reference here.
    private static final String APP_ID = "PUBLIC:AccessibilityTestUIKit.ipa";

    public static void main(String[] args) throws Exception {

        System.out.println("Test Started — Accessibility iOS");

        // ── Credentials ─────────────────────────────────────────────────────
        String apiKey            = System.getenv("APPLITOOLS_API_KEY");
        String serverUrl         = System.getenv("APPLITOOLS_SERVER_URL"); // optional; defaults to Applitools public cloud if unset
        String perfectoCloudName = System.getenv("PERFECTO_CLOUD_NAME");
        String perfectoToken     = System.getenv("PERFECTO_SECURITY_TOKEN");

        // ── Capabilities ────────────────────────────────────────────────────
        DesiredCapabilities capabilities = new DesiredCapabilities();

        capabilities.setCapability("platformName",            "iOS");
        capabilities.setCapability("appium:automationName",   "XCUITest");
        capabilities.setCapability("appium:deviceName",       "00008140-00015900149B001C");
        capabilities.setCapability("appium:platformVersion",  "18.4.1");
        capabilities.setCapability("appium:newCommandTimeout", "300");
        capabilities.setCapability("appium:noReset",          false);
        capabilities.setCapability("appium:app",              APP_ID);

        System.out.println("Capabilities set");

        // ── NML ─────────────────────────────────────────────────────────────
        // Eyes.setMobileCapabilities injects appium:processArguments. Perfecto
        // does not require it to be nested under perfecto:options, so it stays
        // a plain top-level Appium capability.
        Eyes.setMobileCapabilities(capabilities, apiKey, serverUrl);

        System.out.println("Eyes.setMobileCapabilities() done");

        // ── perfecto:options ────────────────────────────────────────────────
        Map<String, Object> perfectoOptions = new HashMap<>();
        perfectoOptions.put("securityToken", perfectoToken);

        capabilities.setCapability("perfecto:options", perfectoOptions);

        // ── Driver ──────────────────────────────────────────────────────────
        System.out.println("Initialising IOSDriver");

        IOSDriver driver = new IOSDriver(
                new URL("https://" + perfectoCloudName + ".perfectomobile.com/nexperience/perfectomobile/wd/hub"),
                capabilities
        );

        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));

        System.out.println("IOSDriver ready");

        // ── Eyes ────────────────────────────────────────────────────────────
        Eyes eyes = new Eyes();

        Configuration config = new Configuration();
        config.setApiKey(apiKey);
        if (serverUrl != null) {
            config.setServerUrl(serverUrl);
        }
        config.setUseDom(true);
        config.setSendDom(true);
        eyes.setConfiguration(config);

        eyes.setBatch(new BatchInfo("Java Perfecto | Static/Slicing Dynamic | NML | iOS Accessibility"));

        try {

            eyes.open(
                    driver,
                    "Perfecto iOS Accessibility App",
                    "iOS Accessibility Validation"
            );
            System.out.println("Eyes open");


            eyes.check("Main Screen", Target.window().fully(false));
            System.out.println("Checked: Main Screen");

            eyes.check("Main Screen | Fully", Target.window().fully());

            eyes.close();
            System.out.println("Eyes closed");

        } catch (Exception e) {

            eyes.abort();
            System.out.println("Exception — eyes aborted: " + e.getMessage());
            throw e;

        } finally {

            driver.quit();
            System.out.println("Driver quit");
        }
    }
}
