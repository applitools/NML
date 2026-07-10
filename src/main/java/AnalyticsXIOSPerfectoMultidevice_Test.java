import com.applitools.eyes.BatchInfo;
import com.applitools.eyes.appium.Eyes;
import com.applitools.eyes.appium.Target;
import com.applitools.eyes.config.Configuration;
import com.applitools.eyes.visualgrid.model.IosMultiDeviceTarget;
import io.appium.java_client.ios.IOSDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.remote.Command;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.DriverCommand;
import org.openqa.selenium.remote.RemoteWebElement;
import org.openqa.selenium.remote.Response;

import java.net.URL;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;

/**
 * iOS AnalyticsX App — Applitools NML (multi-device) + Perfecto Real Device
 *
 * ENV VARS:
 *   APPLITOOLS_API_KEY   — Applitools API key
 *   PERFECTO_CLOUD_NAME  — Perfecto cloud name
 *   PERFECTO_SECURITY_TOKEN — Perfecto security token
 *   FLOW                 — compact | full  (default: full)
 *                          compact → Compact Dashboard → Compact Visual AI Playground
 *                          full    → Dashboard → Visual AI Playground
 *
 * APP:
 *   Application2 — AnalyticsX app (SwiftUI or UIKit real device IPA)
 *   Upload the IPA to your Perfecto repository and replace the hardcoded
 *   value in APP_ID below with the returned PERFECTO:REPOSITORY:... reference.
 */
public class AnalyticsXIOSPerfectoMultidevice_Test {

    // ── App ID ──────────────────────────────────────────────────────────────
    // TODO: upload AnalyticsXUIKit.ipa to the Perfecto repository and paste the reference here.
    private static final String APP_ID = "PUBLIC:AnalyticsXUIKit.ipa";

    public static void main(String[] args) throws Exception {

        System.out.println("Test Started — AnalyticsX iOS");

        // ── Toggles ─────────────────────────────────────────────────────────
        String flow =
                java.util.Optional.ofNullable(System.getenv("FLOW"))
                        .orElse("full");

        System.out.println("FLOW = " + flow);

        // ── Credentials ─────────────────────────────────────────────────────
        String apiKey            = System.getenv("APPLITOOLS_API_KEY");
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
        Eyes.setMobileCapabilities(capabilities, apiKey);

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
        System.setProperty("APPLITOOLS_SHOW_LOGS",    "true");
        System.setProperty("APPLITOOLS_VERBOSE_LOGS", "true");

        Eyes eyes = new Eyes();
        Configuration config = new Configuration();
        config.setApiKey(apiKey);
        config.setUseDom(true);
        config.setSendDom(true);
        config.addMultiDeviceTarget(IosMultiDeviceTarget.iPhone_11_Pro(), IosMultiDeviceTarget.iPhone_11_Pro_Max());
        eyes.setConfiguration(config);


        eyes.setBatch(new BatchInfo("Java Perfecto | Static/Slicing Dynamic | NML | iOS AnalyticsX | Multi Device"));

        try {

            eyes.open(
                    driver,
                    "Perfecto iOS AnalyticsX App",
                    "iOS AnalyticsX Validation"
            );
            System.out.println("Eyes open");

            // ── Screen 1: Login ──────────────────────────────────────────────
            eyes.check("Main Page", Target.window().fully(false));
            System.out.println("Checked: Main Page");

            eyes.check("Main Page | Fully", Target.window().fully());

            findByAccessibilityId(driver, "loginTitle");
            System.out.println("Login page visible");

            Thread.sleep(2000);

            WebElement loginButton = findByAccessibilityId(driver, "loginButton");

            if (!loginButton.isDisplayed()) {
                driver.executeScript(
                        "mobile: dragFromToForDuration",
                        Map.of(
                                "duration", 1,
                                "fromX", 200, "fromY", 300,
                                "toX",   200, "toY",   1400
                        )
                );
            }

            loginButton.click();
            System.out.println("Login button clicked");

            // ── Screen 2: Flow Selector ──────────────────────────────────────
            findByAccessibilityId(driver, "flowSelectorTitle");

            eyes.check("Flow Selector", Target.window().fully(false));
            System.out.println("Checked: Flow Selector");

            // ── Flow Branch ──────────────────────────────────────────────────
            if (flow.equals("compact")) {

                runCompactFlow(driver, eyes);

            } else {

                runFullFlow(driver, eyes);
            }

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

    // ── Compact Flow ─────────────────────────────────────────────────────────
    private static void runCompactFlow(IOSDriver driver, Eyes eyes)
            throws Exception {

        System.out.println("Running COMPACT flow");

        findByAccessibilityId(driver, "compactFlowCard").click();

        Thread.sleep(3000);

        eyes.check("Compact Dashboard", Target.window());
        System.out.println("Checked: Compact Dashboard");

        findByAccessibilityId(driver, "compactVisualAICard").click();

        Thread.sleep(1000);

        eyes.check("Compact Visual AI Playground", Target.window());
        System.out.println("Checked: Compact Visual AI Playground");
    }

    // ── Full Flow ─────────────────────────────────────────────────────────────
    private static void runFullFlow(IOSDriver driver, Eyes eyes)
            throws Exception {

        System.out.println("Running FULL flow");

        findByAccessibilityId(driver, "fullFlowCard").click();

        Thread.sleep(3000);

        findByAccessibilityId(driver, "dashboardTitle");

        eyes.check("Dashboard Screen", Target.window());
        System.out.println("Checked: Dashboard Screen");

        Thread.sleep(2000);

        findByAccessibilityId(driver, "visualAIPlaygroundCard").click();

        Thread.sleep(3000);

        findByAccessibilityId(driver, "playgroundTitle");

        Thread.sleep(2000);

        eyes.check("Visual AI Playground", Target.window());
        System.out.println("Checked: Visual AI Playground");
    }

    // ── Perfecto legacy-protocol workaround ────────────────────────────────────
    // Perfecto's real device sessions can return element references in the legacy
    // JSON Wire Protocol shape ({"ELEMENT": "<id>"}) instead of the W3C shape
    // ({"element-6066-11e4-a52e-4f735466cecf": "<id>"}), which Selenium's client-side
    // findElement() cannot auto-convert to a WebElement (causes a ClassCastException).
    // This bypasses that by executing the find command directly and wrapping whichever
    // element id key comes back into a RemoteWebElement ourselves.
    private static WebElement findByAccessibilityId(IOSDriver driver, String accessibilityId)
            throws java.io.IOException {
        Response response = driver.getCommandExecutor().execute(
                new Command(driver.getSessionId(), DriverCommand.FIND_ELEMENT,
                        Map.of("using", "accessibility id", "value", accessibilityId)));

        Object value = response.getValue();
        if (value instanceof WebElement) {
            return (WebElement) value;
        }

        Map<?, ?> raw = (Map<?, ?>) value;
        Object elementId = raw.containsKey("ELEMENT")
                ? raw.get("ELEMENT")
                : raw.get("element-6066-11e4-a52e-4f735466cecf");

        RemoteWebElement element = new RemoteWebElement();
        element.setParent(driver);
        element.setId(String.valueOf(elementId));
        return element;
    }
}
