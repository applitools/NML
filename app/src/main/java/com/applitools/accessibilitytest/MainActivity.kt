package com.applitools.accessibilitytest

import android.content.res.Configuration
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.Switch
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.applitools.android.ApplitoolsMobile;


class MainActivity : AppCompatActivity() {

    // ─── Hero badge views ─────────────────────────────────────────────────────
    private lateinit var tvTextSizeLabel: TextView
    private lateinit var tvFontScaleValue: TextView

    // ─── Metric panel ─────────────────────────────────────────────────────────
    private lateinit var tvMetricFontScale: TextView
    private lateinit var tvMetricChecklist: TextView

    // ─── Checklist rows ───────────────────────────────────────────────────────
    private lateinit var rowFont: LinearLayout
    private lateinit var rowReader: LinearLayout
    private lateinit var rowContrast: LinearLayout
    private lateinit var rowTouch: LinearLayout

    // ─── Checkbox containers ──────────────────────────────────────────────────
    private lateinit var cbFont: FrameLayout
    private lateinit var cbReader: FrameLayout
    private lateinit var cbContrast: FrameLayout
    private lateinit var cbTouch: FrameLayout

    // ─── Checkmark text views ─────────────────────────────────────────────────
    private lateinit var checkMarkFont: TextView
    private lateinit var checkMarkReader: TextView
    private lateinit var checkMarkContrast: TextView
    private lateinit var checkMarkTouch: TextView

    // ─── Input section ────────────────────────────────────────────────────────
    private lateinit var etTesterName: EditText
    private lateinit var switchReminders: Switch

    // ─── Priority buttons ─────────────────────────────────────────────────────
    private lateinit var btnPriorityStandard: Button
    private lateinit var btnPriorityLargeText: Button
    private lateinit var btnPriorityScreenReader: Button

    // ─── Action buttons ───────────────────────────────────────────────────────
    private lateinit var btnStartTest: Button
    private lateinit var btnReset: Button

    // ─── State ────────────────────────────────────────────────────────────────
    private data class CheckState(
        var font: Boolean = true,
        var reader: Boolean = false,
        var contrast: Boolean = false,
        var touch: Boolean = false
    ) {
        val completedCount: Int
            get() = listOf(font, reader, contrast, touch).count { it }
        val total: Int = 4
    }

    private var checkState = CheckState()
    private var selectedPriority = "Large text"   // matches RN default

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        ApplitoolsMobile.init(this);
        setContentView(R.layout.activity_main)

        bindViews()
        applyInitialState()
        wireListeners()
        updateFontScaleViews()
    }

    // ── Bind all view references ────────────────────────────────────────────
    private fun bindViews() {
        tvTextSizeLabel       = findViewById(R.id.tvTextSizeLabel)
        tvFontScaleValue      = findViewById(R.id.tvFontScaleValue)

        tvMetricFontScale     = findViewById(R.id.tvMetricFontScale)
        tvMetricChecklist     = findViewById(R.id.tvMetricChecklist)

        rowFont               = findViewById(R.id.rowFont)
        rowReader             = findViewById(R.id.rowReader)
        rowContrast           = findViewById(R.id.rowContrast)
        rowTouch              = findViewById(R.id.rowTouch)

        cbFont                = findViewById(R.id.cbFont)
        cbReader              = findViewById(R.id.cbReader)
        cbContrast            = findViewById(R.id.cbContrast)
        cbTouch               = findViewById(R.id.cbTouch)

        checkMarkFont         = findViewById(R.id.checkMarkFont)
        checkMarkReader       = findViewById(R.id.checkMarkReader)
        checkMarkContrast     = findViewById(R.id.checkMarkContrast)
        checkMarkTouch        = findViewById(R.id.checkMarkTouch)

        etTesterName          = findViewById(R.id.etTesterName)
        switchReminders       = findViewById(R.id.switchReminders)

        btnPriorityStandard   = findViewById(R.id.btnPriorityStandard)
        btnPriorityLargeText  = findViewById(R.id.btnPriorityLargeText)
        btnPriorityScreenReader = findViewById(R.id.btnPriorityScreenReader)

        btnStartTest          = findViewById(R.id.btnStartTest)
        btnReset              = findViewById(R.id.btnReset)
    }

    // ── Apply the initial UI state that mirrors the RN defaults ─────────────
    private fun applyInitialState() {
        // Checklist: font = true, rest = false
        applyCheckState(rowFont,     cbFont,     checkMarkFont,     checkState.font)
        applyCheckState(rowReader,   cbReader,   checkMarkReader,   checkState.reader)
        applyCheckState(rowContrast, cbContrast, checkMarkContrast, checkState.contrast)
        applyCheckState(rowTouch,    cbTouch,    checkMarkTouch,    checkState.touch)
        updateChecklistMetric()

        // Priority: "Large text" selected by default
        applyPrioritySelection()
    }

    // ── Wire all click listeners ─────────────────────────────────────────────
    private fun wireListeners() {
        // Checklist toggles
        rowFont.setOnClickListener    { toggleCheck("font") }
        rowReader.setOnClickListener  { toggleCheck("reader") }
        rowContrast.setOnClickListener{ toggleCheck("contrast") }
        rowTouch.setOnClickListener   { toggleCheck("touch") }

        // Priority buttons
        btnPriorityStandard.setOnClickListener     { selectPriority("Standard") }
        btnPriorityLargeText.setOnClickListener    { selectPriority("Large text") }
        btnPriorityScreenReader.setOnClickListener { selectPriority("Screen reader") }

        // Start Test
        btnStartTest.setOnClickListener {
            val name = etTesterName.text.toString().trim()
            val displayName = if (name.isEmpty()) "Unknown" else name
            val msg = "Test started by $displayName — priority: $selectedPriority"
            Toast.makeText(this, msg, Toast.LENGTH_SHORT).show()
        }

        // Reset
        btnReset.setOnClickListener {
            resetAll()
        }
    }

    // ── Toggle a checklist item ──────────────────────────────────────────────
    private fun toggleCheck(key: String) {
        when (key) {
            "font"     -> checkState = checkState.copy(font     = !checkState.font)
            "reader"   -> checkState = checkState.copy(reader   = !checkState.reader)
            "contrast" -> checkState = checkState.copy(contrast = !checkState.contrast)
            "touch"    -> checkState = checkState.copy(touch    = !checkState.touch)
        }
        applyCheckState(rowFont,     cbFont,     checkMarkFont,     checkState.font)
        applyCheckState(rowReader,   cbReader,   checkMarkReader,   checkState.reader)
        applyCheckState(rowContrast, cbContrast, checkMarkContrast, checkState.contrast)
        applyCheckState(rowTouch,    cbTouch,    checkMarkTouch,    checkState.touch)
        updateChecklistMetric()
    }

    // ── Apply visual state to a single checklist row ─────────────────────────
    private fun applyCheckState(
        row: LinearLayout,
        checkbox: FrameLayout,
        checkMark: TextView,
        checked: Boolean
    ) {
        if (checked) {
            row.setBackgroundResource(R.drawable.bg_check_row_selected)
            checkbox.setBackgroundResource(R.drawable.bg_checkbox_selected)
            checkMark.setTextColor(getColor(R.color.white))
        } else {
            row.setBackgroundResource(R.drawable.bg_check_row_normal)
            checkbox.setBackgroundResource(R.drawable.bg_checkbox_normal)
            checkMark.setTextColor(android.graphics.Color.TRANSPARENT)
        }

        // Update accessibility content description
        val checkedText = if (checked) "Checked" else "Not checked"
        val baseDesc = when (row.id) {
            R.id.rowFont     -> "Font scaling. Increase system font size and confirm text wraps cleanly."
            R.id.rowReader   -> "Screen reader. Use TalkBack to check labels, roles, and state."
            R.id.rowContrast -> "Contrast. Confirm selected, disabled, and body text remain readable."
            R.id.rowTouch    -> "Touch targets. Buttons and controls should remain easy to tap at large text."
            else             -> ""
        }
        row.contentDescription = "$baseDesc $checkedText"
    }

    // ── Update checklist metric label ─────────────────────────────────────────
    private fun updateChecklistMetric() {
        tvMetricChecklist.text = "${checkState.completedCount}/${checkState.total}"
    }

    // ── Priority selection ───────────────────────────────────────────────────
    private fun selectPriority(priority: String) {
        selectedPriority = priority
        applyPrioritySelection()
    }

    private fun applyPrioritySelection() {
        val buttons = mapOf(
            "Standard"      to btnPriorityStandard,
            "Large text"    to btnPriorityLargeText,
            "Screen reader" to btnPriorityScreenReader
        )
        buttons.forEach { (label, btn) ->
            val selected = label == selectedPriority
            btn.setBackgroundResource(
                if (selected) R.drawable.bg_segment_selected else R.drawable.bg_segment_normal
            )
            btn.setTextColor(
                if (selected) getColor(R.color.white) else getColor(R.color.gray_700)
            )
            btn.contentDescription = "$label priority${if (selected) ", selected" else ""}"
        }
    }

    // ── Reset everything to initial state ────────────────────────────────────
    private fun resetAll() {
        etTesterName.setText("")
        switchReminders.isChecked = true
        selectedPriority = "Large text"
        checkState = CheckState()   // default: font=true, rest=false

        applyInitialState()
        Toast.makeText(this, "Reset", Toast.LENGTH_SHORT).show()
    }

    // ── Font scale helpers ───────────────────────────────────────────────────
    private fun fontSizeLabel(fontScale: Float): String = when {
        fontScale < 0.95f -> "Small"
        fontScale < 1.05f -> "Default"
        fontScale < 1.20f -> "Large"
        fontScale < 1.45f -> "Larger"
        fontScale < 1.75f -> "Largest"
        else              -> "Accessibility"
    }

    private fun updateFontScaleViews() {
        val fontScale = resources.configuration.fontScale
        val label = fontSizeLabel(fontScale)
        val scaleText = "%.2fx".format(fontScale)

        tvTextSizeLabel.text    = label
        tvFontScaleValue.text   = scaleText
        tvMetricFontScale.text  = scaleText
    }

    // ── Configuration changes (fontScale, uiMode) ────────────────────────────
    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        updateFontScaleViews()
    }
}
