# Desktop Mode

Enable Android's built-in desktop mode and freeform window support.

## Status

**UNTESTED** — Settings applied via ADB but not verified on real hardware yet. Needs reboot and testing.

## What This Does

- Enables desktop mode when connecting to external display via USB-C to HDMI
- Enables freeform windows (floating, resizable app windows)
- Forces apps to allow resizing

## How It Works

Android 10+ has a hidden desktop mode that activates when you connect to an external display. On stock Android, this is hidden behind Developer Options. On Samsung devices, this is replaced by DeX.

These settings enable the AOSP desktop mode:
- `force_desktop_mode_on_external_displays` — show desktop UI on external monitor
- `enable_freeform_support` — allow floating windows
- `force_resizable_activities` — force all apps to support resizing

## Quick Start

### ADB

```bash
# Enable desktop mode on external displays
adb shell settings put global force_desktop_mode_on_external_displays 1

# Enable freeform windows
adb shell settings put global enable_freeform_support 1

# Force apps to be resizable
adb shell settings put global force_resizable_activities 1

# Reboot required
adb reboot
```

### After Reboot

**Freeform mode:**
1. Open an app
2. Swipe up and hold for recent apps
3. Long-press the app icon
4. Select "Freeform" from the menu
5. App becomes a floating, resizable window

**Desktop mode:**
1. Connect phone to monitor via USB-C to HDMI
2. Phone should show desktop UI instead of mirroring

## Requirements

- Root access
- USB-C to HDMI adapter/cable (for external display)
- Samsung Exynos device

## Limitations

- Desktop mode is basic AOSP implementation, not Samsung DeX
- Not all apps support freeform mode
- May require additional apps (like Taskbar launcher) for good desktop experience

## How to Verify

After applying settings and rebooting:
1. Check if "Freeform" option appears in recent apps menu
2. Connect to external monitor and check if desktop UI appears

## Credits

- komori

## License

CC-BY-NC-SA-4.0
