package com.ultracam.display

import android.os.Bundle
import android.widget.LinearLayout
import android.widget.RadioButton
import android.widget.RadioGroup
import android.widget.TextView
import android.app.Activity
import java.io.File

class MainActivity : Activity() {

    private val MDNIE_PATH = "/sys/class/mdnie/mdnie/mode"
    private val SETTINGS_KEY = "screen_mode_setting"

    private val modes = arrayOf(
        Mode(0, "Dynamic", "Maximum saturation and contrast", "#FF6B35"),
        Mode(1, "Standard", "sRGB color accurate", "#4CAF50"),
        Mode(2, "Natural", "Balanced, adaptive", "#2196F3"),
        Mode(3, "Movie", "DCI-P3, warm, cinematic", "#9C27B0"),
        Mode(4, "Auto", "Samsung adaptive algorithm", "#FF9800")
    )

    private lateinit var radioGroup: RadioGroup
    private lateinit var statusText: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        radioGroup = findViewById(R.id.radioGroup)
        statusText = findViewById(R.id.statusText)

        // Check root
        if (!checkRoot()) {
            statusText.text = "Root access required"
            statusText.setTextColor(0xFFFF5252.toInt())
            return
        }

        // Create radio buttons
        modes.forEach { mode ->
            val radioButton = RadioButton(this).apply {
                id = mode.value
                text = "${mode.name}\n${mode.description}"
                textSize = 16f
                setPadding(32, 24, 32, 24)
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                ).apply {
                    setMargins(0, 8, 0, 8)
                }
            }
            radioGroup.addView(radioButton)
        }

        // Read current mode
        val currentMode = readMdnIeMode()
        if (currentMode >= 0) {
            radioGroup.check(currentMode)
            statusText.text = "Current: ${modes[currentMode].name}"
        }

        // Handle selection
        radioGroup.setOnCheckedChangeListener { _, checkedId ->
            if (checkedId >= 0) {
                val mode = modes.first { it.value == checkedId }
                if (writeMdnIeMode(checkedId)) {
                    statusText.text = "Applied: ${mode.name}"
                    statusText.setTextColor(0xFF4CAF50.toInt())
                } else {
                    statusText.text = "Failed to apply ${mode.name}"
                    statusText.setTextColor(0xFFFF5252.toInt())
                }
            }
        }
    }

    private fun checkRoot(): Boolean {
        return try {
            val process = Runtime.getRuntime().exec(arrayOf("su", "-c", "id"))
            val output = process.inputStream.bufferedReader().readText()
            process.waitFor()
            output.contains("uid=0")
        } catch (e: Exception) {
            false
        }
    }

    private fun readMdnIeMode(): Int {
        return try {
            val process = Runtime.getRuntime().exec(
                arrayOf("su", "-c", "cat $MDNIE_PATH")
            )
            val output = process.inputStream.bufferedReader().readText().trim()
            process.waitFor()
            output.toIntOrNull() ?: -1
        } catch (e: Exception) {
            -1
        }
    }

    private fun writeMdnIeMode(mode: Int): Boolean {
        return try {
            val process = Runtime.getRuntime().exec(
                arrayOf("su", "-c", "echo $mode > $MDNIE_PATH")
            )
            process.waitFor()
            // Also save to Android settings for persistence
            val settingsProcess = Runtime.getRuntime().exec(
                arrayOf("su", "-c", "settings put system $SETTINGS_KEY $mode")
            )
            settingsProcess.waitFor()
            true
        } catch (e: Exception) {
            false
        }
    }

    data class Mode(val value: Int, val name: String, val description: String, val color: String)
}
