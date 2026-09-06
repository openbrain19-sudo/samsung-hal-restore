package com.ultracam.display

import android.os.Bundle
import android.widget.LinearLayout
import android.widget.RadioButton
import android.widget.RadioGroup
import android.widget.SeekBar
import android.widget.TextView
import android.app.Activity

class MainActivity : Activity() {

    private val MDNIE_MODE = "/sys/class/mdnie/mdnie/mode"
    private val MDNIE_HDR = "/sys/class/mdnie/mdnie/hdr"
    private val MDNIE_NIGHT = "/sys/class/mdnie/mdnie/night_mode"
    private val MDNIE_BYPASS = "/sys/class/mdnie/mdnie/bypass"
    private val MDNIE_STATUS = "/sys/class/mdnie/mdnie/mdnie"
    private val SETTINGS_KEY = "screen_mode_setting"

    private val modes = arrayOf(
        Mode(0, "Dynamic", "Maximum saturation and contrast"),
        Mode(1, "Standard", "sRGB color accurate"),
        Mode(2, "Natural", "Balanced, adaptive"),
        Mode(3, "Movie", "DCI-P3, warm, cinematic"),
        Mode(4, "Auto", "Samsung adaptive algorithm")
    )

    private val hdrModes = arrayOf(
        Mode(0, "HDR Off", "Disable HDR processing"),
        Mode(1, "HDR Mode 1", "HDR tone mapping variant 1"),
        Mode(2, "HDR Mode 2", "HDR tone mapping variant 2"),
        Mode(3, "HDR Mode 3", "HDR tone mapping variant 3")
    )

    private lateinit var modeGroup: RadioGroup
    private lateinit var hdrGroup: RadioGroup
    private lateinit var nightLevelText: TextView
    private lateinit var nightSeekBar: SeekBar
    private lateinit var bypassText: TextView
    private lateinit var statusText: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        modeGroup = findViewById(R.id.modeGroup)
        hdrGroup = findViewById(R.id.hdrGroup)
        nightLevelText = findViewById(R.id.nightLevelText)
        nightSeekBar = findViewById(R.id.nightSeekBar)
        bypassText = findViewById(R.id.bypassText)
        statusText = findViewById(R.id.statusText)

        if (!checkRoot()) {
            statusText.text = "Root access required"
            statusText.setTextColor(0xFFFF5252.toInt())
            return
        }

        // Create mode radio buttons
        modes.forEach { mode ->
            val rb = RadioButton(this).apply {
                id = mode.value
                text = "${mode.name}\n${mode.description}"
                textSize = 15f
                setPadding(24, 16, 24, 16)
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                ).apply { setMargins(0, 4, 0, 4) }
            }
            modeGroup.addView(rb)
        }

        // Create HDR radio buttons
        hdrModes.forEach { mode ->
            val rb = RadioButton(this).apply {
                id = 100 + mode.value
                text = "${mode.name}\n${mode.description}"
                textSize = 15f
                setPadding(24, 16, 24, 16)
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                ).apply { setMargins(0, 4, 0, 4) }
            }
            hdrGroup.addView(rb)
        }

        // Read current state
        val currentMode = readSysfs(MDNIE_MODE)
        val currentHdr = readSysfs(MDNIE_HDR)
        val currentNight = readSysfs(MDNIE_NIGHT)
        val currentBypass = readSysfs(MDNIE_BYPASS)

        if (currentMode >= 0) modeGroup.check(currentMode)
        if (currentHdr >= 0) hdrGroup.check(100 + currentHdr)

        // Parse night_mode "on level" format
        if (currentNight.isNotEmpty()) {
            val parts = currentNight.split(" ")
            if (parts.size >= 2 && parts[0] == "1") {
                val level = parts[1].toIntOrNull() ?: 0
                nightSeekBar.progress = level
                nightLevelText.text = "Eye Comfort: Level $level"
            } else {
                nightSeekBar.progress = 0
                nightLevelText.text = "Eye Comfort: Off"
            }
        }

        bypassText.text = if (currentBypass == "1") "Bypass: ON" else "Bypass: Off"

        // Mode selection
        modeGroup.setOnCheckedChangeListener { _, checkedId ->
            if (checkedId >= 0) {
                writeSysfs(MDNIE_MODE, checkedId.toString())
                writeSettings(SETTINGS_KEY, checkedId.toString())
                statusText.text = "Mode: ${modes[checkedId].name}"
                statusText.setTextColor(0xFF4CAF50.toInt())
            }
        }

        // HDR selection
        hdrGroup.setOnCheckedChangeListener { _, checkedId ->
            if (checkedId >= 100) {
                val hdrVal = (checkedId - 100).toString()
                writeSysfs(MDNIE_HDR, hdrVal)
                statusText.text = "HDR: ${hdrModes[checkedId - 100].name}"
                statusText.setTextColor(0xFF4CAF50.toInt())
            }
        }

        // Night mode seekbar
        nightSeekBar.setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {
            override fun onProgressChanged(seekBar: SeekBar?, progress: Int, fromUser: Boolean) {
                nightLevelText.text = if (progress > 0) "Eye Comfort: Level $progress" else "Eye Comfort: Off"
            }
            override fun onStartTrackingTouch(seekBar: SeekBar?) {}
            override fun onStopTrackingTouch(seekBar: SeekBar?) {
                val level = seekBar?.progress ?: 0
                if (level > 0) {
                    writeSysfs(MDNIE_NIGHT, "1 $level")
                } else {
                    writeSysfs(MDNIE_NIGHT, "0 0")
                }
            }
        })

        // Bypass toggle
        findViewById<android.widget.Button>(R.id.bypassButton).setOnClickListener {
            val current = readSysfs(MDNIE_BYPASS)
            val new = if (current == "1") "0" else "1"
            writeSysfs(MDNIE_BYPASS, new)
            bypassText.text = if (new == "1") "Bypass: ON" else "Bypass: Off"
            statusText.text = if (new == "1") "Bypass enabled" else "Bypass disabled"
            statusText.setTextColor(0xFF4CAF50.toInt())
        }

        statusText.text = "Ready"
    }

    private fun checkRoot(): Boolean {
        return try {
            val p = Runtime.getRuntime().exec(arrayOf("su", "-c", "id"))
            val out = p.inputStream.bufferedReader().readText()
            p.waitFor()
            out.contains("uid=0")
        } catch (e: Exception) { false }
    }

    private fun readSysfs(path: String): String {
        return try {
            val p = Runtime.getRuntime().exec(arrayOf("su", "-c", "cat $path"))
            val out = p.inputStream.bufferedReader().readText().trim()
            p.waitFor()
            out
        } catch (e: Exception) { "" }
    }

    private fun readSysfsInt(path: String): Int {
        val v = readSysfs(path)
        return v.toIntOrNull() ?: -1
    }

    private fun writeSysfs(path: String, value: String): Boolean {
        return try {
            val p = Runtime.getRuntime().exec(arrayOf("su", "-c", "echo $value > $path"))
            p.waitFor()
            true
        } catch (e: Exception) { false }
    }

    private fun writeSettings(key: String, value: String) {
        try {
            val p = Runtime.getRuntime().exec(arrayOf("su", "-c", "settings put system $key $value"))
            p.waitFor()
        } catch (e: Exception) {}
    }

    data class Mode(val value: Int, val name: String, val description: String)
}
