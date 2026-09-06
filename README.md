# Samsung HAL Restore

Restoring Samsung vendor HAL features on custom ROMs.

## The Problem

Samsung Exynos devices running LineageOS and other custom ROMs lose access to Samsung-specific hardware features. The common assumption is that these features "don't work" on custom ROMs. **This is wrong.** The vendor HAL is still there. The vendor keys are still accessible. Nobody just tried.

## What This Project Does

Proves that Samsung vendor features work on custom ROMs and builds tools to access them.

## What's Working

### Camera Vendor Keys
All Samsung-specific camera2 vendor tags (beauty mode, HDR, scene optimization, etc.) work on custom ROMs. See [UltraCam-Aperture](https://github.com/openbrain19-sudo/UltraCam-Aperture) for the camera app.

### Display (mDNIe)
Full control of Samsung's display processing engine via sysfs:

| Feature | Status | Details |
|---------|--------|---------|
| Color Profiles | Working | Dynamic, Standard, Natural, Movie, Auto |
| HDR Processing | Working | 3 HDR modes via mDNIe |
| Eye Comfort Shield | Working | Blue light filter with adjustable intensity |
| Bypass Mode | Working | Disable mDNIe entirely |

See [display/adaptive-tuning](display/adaptive-tuning/) for scripts and details.

### VoLTE
Phone calls on Samsung Exynos when carriers shut down 2G/3G. See [voLTE-exynos](https://github.com/openbrain19-sudo/voLTE-exynos).

## What's In Progress

### Audio HAL
Samsung's audio HAL (`audio.primary.universal990.so`) is present on vendor partition. Dolby config (`dax-default.xml`) exists. Samsung's custom audio processing is not utilized on custom ROMs. See [audio/](audio/).

### Haptics
Samsung's haptic engine sysfs interface exists at `/sys/devices/virtual/timed_output/vibrator/haptic_engine`. Basic vibrator works, advanced patterns not hooked up. See [haptics/](haptics/).

## What's Planned

- **Samsung DeX** — Desktop mode when plugging into a monitor
- **Dolby Atmos Samsung profiles** — Custom Dolby tuning
- **UHQ Upscaler** — Proprietary DSP for wired headphone audio
- **Advanced haptics** — Samsung's custom vibration patterns

## Quick Start

### Android App (Recommended)
Install the APK, grant root when prompted. Pick a mode, done.

```bash
# Build the app
./gradlew assembleDebug

# APK at: app/build/outputs/apk/debug/app-debug.apk
```

### Shell Script
```bash
# Push to phone
adb push mdnie-controller.sh /sdcard/

# Interactive mode
adb shell su -c "sh /sdcard/mdnie-controller.sh"

# Direct commands
adb shell su -c "sh /sdcard/mdnie-controller.sh mode 3"
adb shell su -c "sh /sdcard/mdnie-controller.sh hdr 1"
adb shell su -c "sh /sdcard/mdnie-controller.sh night 1 10"
```

### Direct ADB
```bash
# Check status
adb shell su -c "cat /sys/class/mdnie/mdnie/mdnie"

# Set display mode (0-4)
adb shell su -c "echo 3 > /sys/class/mdnie/mdnie/mode"

# Set HDR (0-3)
adb shell su -c "echo 1 > /sys/class/mdnie/mdnie/hdr"

# Set eye comfort (format: "on level")
adb shell su -c "echo 1 10 > /sys/class/mdnie/mdnie/night_mode"
```

## How It Works

Samsung's vendor HAL lives on the vendor partition. When you flash a custom ROM, the vendor partition stays. The HAL blobs are still there. The vendor keys are still accessible through standard Android HAL interfaces (Camera2, Display, Audio, etc.).

The features don't "not work" — they just haven't been hooked up. This project hooks them up.

## Device Support

- Samsung Galaxy S20 Ultra (SM-G988B) — Exynos 990, codename z3s
- Likely works on other Exynos 990 devices (S20/S20+/Note 20 series)

## Requirements

- Root access (APatch, Magisk, or enable in Developer Options)
- ADB for scripts (not needed for the app)

## Credits

- **komori** — Discovery, testing, and implementation
- **ExtremeXT** — LineageOS for Exynos 990, kernel source
- **tdrkDev** — Samsung camera framework reverse engineering
- **illusion0001** — SamsungCamera research and APK samples

## License

CC-BY-NC-SA-4.0 — Use it, fork it, edit it. No selling. If you make it public, credit komori. If you make a derivative, it must be open source under the same license.
