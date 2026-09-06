# Samsung Display Settings

Standalone app and scripts for controlling Samsung mDNIe display modes on LineageOS.

## What This Does

Lets you switch between Samsung's 5 color profiles on custom ROMs without needing ADB or a computer.

## Options

### 1. Android App (Recommended)

Install the APK, open it, grant root when prompted. Pick a mode, done.

- Clean UI with all 5 modes
- Changes apply instantly
- No Magisk module needed — just root access

**Requirements:**
- Android 9+ (API 28+)
- Root access (enable in Developer Options, or install Magisk/APatch)

### 2. Shell Script

For people who prefer terminal. Push the script to your phone and run it.

```bash
# Push to phone
adb push mdnie-controller.sh /sdcard/

# Run interactively
adb shell su -c "sh /sdcard/mdnie-controller.sh"

# Or set mode directly
adb shell su -c "sh /sdcard/mdnie-controller.sh 3"
```

### 3. Direct ADB Commands

```bash
# Check current mode
adb shell su -c "cat /sys/class/mdnie/mdnie/mdnie"

# Set mode (0-4)
adb shell su -c "echo 3 > /sys/class/mdnie/mdnie/mode"
```

## Display Modes

| Value | Mode | Description |
|-------|------|-------------|
| 0 | Dynamic | Maximum saturation and contrast |
| 1 | Standard | sRGB color accurate |
| 2 | Natural | Balanced, adaptive |
| 3 | Movie | DCI-P3, warm, cinematic |
| 4 | Auto | Samsung adaptive algorithm |

## Building the App

```bash
# Requires Android SDK and Kotlin
./gradlew assembleDebug

# APK will be at:
# app/build/outputs/apk/debug/app-debug.apk
```

## How It Works

Samsung's mDNIe (mobile Digital Natural Image engine) is a hardware display processor that applies color transformations. The control interface is at `/sys/class/mdnie/mdnie/mode`. This file is owned by `system:system` but SELinux prevents non-root apps from writing to it.

Root access allows the app/script to write directly to the sysfs file, changing the display mode instantly.

## Credits

- komori — Discovery, testing, and implementation

## License

CC-BY-NC-SA-4.0
