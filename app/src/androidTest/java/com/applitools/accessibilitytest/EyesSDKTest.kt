package com.applitools.accessibilitytest

import androidx.test.espresso.Espresso.onView
import androidx.test.espresso.action.ViewActions.click
import androidx.test.espresso.action.ViewActions.closeSoftKeyboard
import androidx.test.espresso.action.ViewActions.scrollTo
import androidx.test.espresso.action.ViewActions.typeText
import androidx.test.espresso.matcher.ViewMatchers.withId
import androidx.test.core.app.ActivityScenario
import androidx.test.ext.junit.rules.ActivityScenarioRule
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.applitools.eyes.android.common.BatchInfo
import com.applitools.eyes.android.espresso.Eyes
import com.applitools.eyes.android.espresso.fluent.Target
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

/**
 * Pixel-based visual checkpoints via the Eyes-Android-Espresso SDK.
 * Mirrors EyesSDKTests in the sibling accessibility-test-uikit (iOS) project.
 */
@RunWith(AndroidJUnit4::class)
class EyesSDKTest {

    @get:Rule
    val activityRule = ActivityScenarioRule(MainActivity::class.java)

    private fun newEyes(): Eyes {
        val eyes = Eyes()
        eyes.setApiKey(BuildConfig.APPLITOOLS_API_KEY)
        val configuration = eyes.configuration
        configuration.setBatch(BatchInfo("Espresso | Accessibility App | Eyes SDK"))
        eyes.configuration = configuration
        return eyes
    }

    @Test
    fun capturesAccessibilityFlow() {
        val eyes = newEyes()
        try {
            eyes.open("AndroidXML", "Accessibility flow")

            eyes.check("Initial state", Target.window().fully(false))

            onView(withId(R.id.rowReader)).perform(scrollTo(), click())
            eyes.check("Screen reader row checked", Target.window())

            onView(withId(R.id.btnPriorityScreenReader)).perform(scrollTo(), click())
            eyes.check("Screen reader priority selected", Target.window())

            onView(withId(R.id.etTesterName)).perform(scrollTo(), typeText("Ada Lovelace"), closeSoftKeyboard())
            eyes.check("Tester name entered", Target.window())

            onView(withId(R.id.btnReset)).perform(scrollTo(), click())
            eyes.check("After reset", Target.window())

            val playgroundScenario = ActivityScenario.launch(VisualAIPlaygroundActivity::class.java)
            eyes.check("Visual AI Playground", Target.window())
            playgroundScenario.close()

            eyes.close(false)
        } finally {
            eyes.abortIfNotClosed()
        }
    }
}
