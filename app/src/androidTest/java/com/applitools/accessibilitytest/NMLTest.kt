package com.applitools.accessibilitytest

import androidx.test.core.app.ActivityScenario
import androidx.test.espresso.Espresso.onView
import androidx.test.espresso.action.ViewActions.click
import androidx.test.espresso.action.ViewActions.closeSoftKeyboard
import androidx.test.espresso.action.ViewActions.scrollTo
import androidx.test.espresso.action.ViewActions.typeText
import androidx.test.espresso.matcher.ViewMatchers.withId
import androidx.test.ext.junit.rules.ActivityScenarioRule
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.applitools.eyes.android.common.BatchInfo
import com.applitools.eyes.android.espresso.Eyes
import com.applitools.eyes.android.espresso.fluent.Target
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

/**
 * Native Mobile Library (NML) visual checkpoints via the Eyes-Android-Espresso SDK.
 * Same Eyes API as EyesSDKTest, but with setNMLScreenshotProvider(true) so captures
 * come from the native view/DOM tree instead of a pixel screenshot.
 * Mirrors NMLCaptureTests in the sibling accessibility-test-uikit (iOS) project.
 */
@RunWith(AndroidJUnit4::class)
class NMLTest {

    @get:Rule
    val activityRule = ActivityScenarioRule(MainActivity::class.java)

    private fun newEyes(): Eyes {
        val eyes = Eyes()
        eyes.setApiKey(BuildConfig.APPLITOOLS_API_KEY)
        val configuration = eyes.configuration
        configuration.setBatch(BatchInfo("Espresso | Accessibility App | NML"))
        configuration.setNMLScreenshotProvider(true)
        eyes.configuration = configuration
        return eyes
    }

    @Test
    fun capturesAccessibilityFlowViaNML() {
        val eyes = newEyes()
        try {
            eyes.open("AndroidXML", "NML accessibility flow")

            eyes.check("Initial state", Target.window().fully())

            val playgroundScenario = ActivityScenario.launch(VisualAIPlaygroundActivity::class.java)
            eyes.check("Visual AI Playground", Target.window().fully())
            playgroundScenario.close()

            eyes.close(false)
        } finally {
            eyes.abortIfNotClosed()
        }
    }
}
