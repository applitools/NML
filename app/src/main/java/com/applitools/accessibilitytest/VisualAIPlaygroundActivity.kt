package com.applitools.accessibilitytest

import android.os.Bundle
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.applitools.android.ApplitoolsMobile
import com.google.android.material.card.MaterialCardView
import java.util.Date
import kotlin.random.Random

/**
 * Mirrors VisualAIPlaygroundViewController from the sibling accessibility-test-uikit
 * (iOS) project: one card per Applitools match algorithm (strict, layout, ignore
 * colors, dynamic content, floating region, ignore region, exact match), plus filler
 * cards to make the screen scrollable, so a single screen can demonstrate every kind
 * of visual diff Eyes can detect/tolerate.
 */
class VisualAIPlaygroundActivity : AppCompatActivity() {

    private val revenue = Random.nextInt(1000, 100000)
    private val activeUsers = Random.nextInt(100, 5000)
    private val cpuUsage = Random.nextInt(1, 100)

    private val scrollFillerCardCount = 6

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        ApplitoolsMobile.init(this)
        setContentView(R.layout.activity_visual_ai_playground)

        bindStrictMatch()
        bindLayoutMatch()
        bindIgnoreColors()
        bindDynamicMatch()
        bindFloatingRegion()
        bindIgnoreRegion()
        addScrollFillerCards()
    }

    private fun bindStrictMatch() {
        val input = findViewById<EditText>(R.id.strictMatchInput)
        val preview = findViewById<TextView>(R.id.strictPreviewLabel)
        input.doAfterTextChanged { preview.text = it }
    }

    private fun bindLayoutMatch() {
        findViewById<TextView>(R.id.layoutRevenueMetric).text = "Revenue: \$$revenue"
        findViewById<TextView>(R.id.layoutActiveUsersMetric).text = "Active Users: $activeUsers"
        findViewById<TextView>(R.id.layoutCPUMetric).text = "CPU Usage: $cpuUsage%"
    }

    private fun bindIgnoreColors() {
        val card = findViewById<MaterialCardView>(R.id.ignoreColorsCard)
        card.setCardBackgroundColor(
            android.graphics.Color.rgb(
                Random.nextInt(0, 256),
                Random.nextInt(0, 256),
                Random.nextInt(0, 256)
            )
        )
    }

    private fun bindDynamicMatch() {
        findViewById<TextView>(R.id.dynamicLastUpdatedMetric).text = "Last Updated: ${Date()}"
    }

    private fun bindFloatingRegion() {
        val chip = findViewById<View>(R.id.movingFloatingChip)
        val card = findViewById<MaterialCardView>(R.id.floatingRegionCard)
        card.post {
            val maxShift = (card.width - chip.width - chip.marginStartPx()).coerceAtLeast(0)
            chip.translationX = Random.nextInt(0, maxShift.coerceAtLeast(1) + 1).toFloat()
        }
    }

    private fun View.marginStartPx(): Int {
        val params = layoutParams as? ViewGroup.MarginLayoutParams
        return params?.marginStart ?: 0
    }

    private fun bindIgnoreRegion() {
        findViewById<TextView>(R.id.timestampText).text = Date().toString()
    }

    private fun addScrollFillerCards() {
        val container = findViewById<ViewGroup>(R.id.scrollFillerContainer)
        for (index in 0 until scrollFillerCardCount) {
            val card = MaterialCardView(this).apply {
                id = View.generateViewId()
                layoutParams = ViewGroup.MarginLayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.WRAP_CONTENT
                ).apply { bottomMargin = dpToPx(16) }
                radius = dpToPx(8).toFloat()
                cardElevation = 0f
                setCardBackgroundColor(getColor(R.color.white))
                strokeColor = getColor(R.color.gray_200)
                strokeWidth = dpToPx(1)
                contentDescription = "scrollCard-$index"
            }
            val title = TextView(this).apply {
                text = getString(R.string.scroll_test_card_title, index + 1)
                setTextColor(getColor(R.color.gray_900))
                textSize = 19f
                setPadding(dpToPx(18), dpToPx(18), dpToPx(18), dpToPx(18))
            }
            card.addView(title)
            container.addView(card)
        }
    }

    private fun dpToPx(dp: Int): Int = (dp * resources.displayMetrics.density).toInt()
}

private fun EditText.doAfterTextChanged(action: (String) -> Unit) {
    addTextChangedListener(object : android.text.TextWatcher {
        override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}
        override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {}
        override fun afterTextChanged(s: android.text.Editable?) {
            action(s?.toString().orEmpty())
        }
    })
}
