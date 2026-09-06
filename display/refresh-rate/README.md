# Forced Refresh Rate

Force 120Hz refresh rate on all apps, including those that normally lock to 60Hz.

## Status

**UNTESTED** — Settings applied via ADB but not verified on real hardware yet. Needs reboot and testing.

## What This Does

- Forces peak refresh rate to 120Hz
- Forces minimum refresh rate to 120Hz
- All apps should run at 120Hz regardless of their default

## How It Works

Samsung's S20 Ultra panel supports:
- 1440x3200 @ 60Hz
- 1080x2400 @ 120Hz
- 1080x2400 @ 96Hz
- 1080x2400 @ 60Hz

The `peak_refresh_rate` and `min_refresh_rate` system settings control which mode the display uses. On stock One UI, the Settings app controls this. On LineageOS, these settings still work.

## Quick Start

### ADB

```bash
# Force 120Hz
adb shell settings put system peak_refresh_rate 120
adb shell settings put system min_refresh_rate 120

# Revert to auto
adb shell settings delete system peak_refresh_rate
adb shell settings delete system min_refresh_rate
```

## Requirements

- Root access
- Samsung Exynos device with 120Hz panel

## How to Verify

After applying, check if the screen looks smoother. You can also use:
```bash
# Check current refresh rate
adb shell dumpsys SurfaceFlinger | grep -i "refresh\|fps"
```

## Credits

- komori

## License

CC-BY-NC-SA-4.0
