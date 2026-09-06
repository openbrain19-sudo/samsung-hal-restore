# Adaptive Display Tuning

Samsung's color profiles (Natural/Vivid/Adaptive) are vendor-specific display settings that work through the display HAL. The HAL is there on custom ROMs, just needs the right metadata.

## Status

Working — Samsung's `screen_mode_setting` system setting controls color profiles via ADB. The vendor HAL on Exynos 990 (S20 Ultra) responds to these settings even on LineageOS.

## Available Profiles

| Value | Profile | Color Space |
|-------|---------|-------------|
| 0 | AMOLED Cinema | DCI-P3 |
| 1 | AMOLED Photo | Adobe RGB |
| 2 | Basic | sRGB |
| 3 | Natural | Adaptive |
| 4 | Vivid | Oversaturated |

## Quick Start

### Windows

Run `switch-profile.bat` and select a profile (0-4).

### Linux/macOS

```bash
chmod +x switch-profile.sh
./switch-profile.sh        # interactive
./switch-profile.sh 4      # set Vivid directly
```

### Manual ADB

```bash
# Check current profile
adb shell settings get system screen_mode_setting

# Set to Vivid
adb shell settings put system screen_mode_setting 4

# Set to Natural
adb shell settings put system screen_mode_setting 3

# Set to AMOLED Cinema (DCI-P3)
adb shell settings put system screen_mode_setting 0
```

## Requirements

- ADB (Android SDK platform-tools)
- USB debugging enabled
- Rooted device (for some operations)
- Samsung Exynos device running LineageOS or custom ROM

## How It Works

Samsung's display HAL uses the `screen_mode_setting` system setting to control which color profile the mDNIe (mobile Digital Natural Image engine) applies. This setting is stored in the Android system database and persists across reboots.

On stock One UI, the Settings app writes this value when you toggle display modes. On custom ROMs, the setting still exists and the vendor HAL still reads it — the UI just doesn't expose it.

Additionally, Samsung's RGB temperature controls are available via:
- `sec_display_temperature_red`
- `sec_display_temperature_green`
- `sec_display_temperature_blue`

These can be adjusted for finer color tuning.

## Troubleshooting

**Setting doesn't change colors:**
- Try opening Settings > Display > Screen Mode and toggling back and forth
- The HAL sometimes needs a UI refresh to pick up the change

**Setting returns null:**
- The setting hasn't been created yet. Set it once with a value and it will persist.

**Colors look wrong after switching:**
- Set back to Natural (3) as a safe default
- The color profiles are calibrated for Samsung's stock panel — custom ROM panels may have different characteristics

## Credits

- komori — Discovery, testing, and implementation
- XDA community — Screen mode research

## License

CC-BY-NC-SA-4.0
