# Adaptive Display Tuning

Samsung's mDNIe (mobile Digital Natural Image engine) controls display color profiles, HDR processing, and eye comfort. On LineageOS, the mDNIe sysfs interface is accessible and fully functional.

## Status

**Working.** Tested on Samsung Galaxy S20 Ultra (SM-G988B) running LineageOS 23.2.

## Available Controls

### Display Modes

| Value | Mode | Description |
|-------|------|-------------|
| 0 | Dynamic | Maximum saturation and contrast |
| 1 | Standard | sRGB color accurate |
| 2 | Natural | Balanced, adaptive |
| 3 | Movie | DCI-P3, warm, cinematic |
| 4 | Auto | Samsung adaptive algorithm |

### HDR Processing

| Value | Mode | Description |
|-------|------|-------------|
| 0 | Off | Disable HDR processing |
| 1 | Mode 1 | HDR tone mapping variant 1 |
| 2 | Mode 2 | HDR tone mapping variant 2 |
| 3 | Mode 3 | HDR tone mapping variant 3 |

### Eye Comfort Shield

Blue light filter with adjustable intensity.

| Format | Description |
|--------|-------------|
| `0 0` | Off |
| `1 5` | Level 5 (light) |
| `1 10` | Level 10 (medium) |
| `1 15` | Level 15 (strong) |
| `1 20` | Level 20 (maximum) |

### Bypass Mode

Disables mDNIe processing entirely. Useful for debugging or getting raw panel output.

| Value | Description |
|-------|-------------|
| 0 | mDNIe enabled (normal) |
| 1 | mDNIe bypassed |

## Quick Start

### Windows

Run `switch-profile.bat` for an interactive menu.

### Linux/macOS

```bash
chmod +x switch-profile.sh
./switch-profile.sh              # interactive
./switch-profile.sh mode 3       # set Movie mode
./switch-profile.sh hdr 1        # enable HDR mode 1
./switch-profile.sh night 1 10   # eye comfort level 10
./switch-profile.sh bypass       # toggle bypass
```

### Direct ADB

```bash
# Check status
adb shell su -c "cat /sys/class/mdnie/mdnie/mdnie"

# Set display mode
adb shell su -c "echo 3 > /sys/class/mdnie/mdnie/mode"

# Set HDR
adb shell su -c "echo 1 > /sys/class/mdnie/mdnie/hdr"

# Set eye comfort
adb shell su -c "echo 1 10 > /sys/class/mdnie/mdnie/night_mode"

# Toggle bypass
adb shell su -c "echo 1 > /sys/class/mdnie/mdnie/bypass"
```

## Requirements

- ADB (Android SDK platform-tools)
- USB debugging enabled
- Root access (APatch or Magisk)
- Samsung Exynos device running LineageOS

## How It Works

Samsung's display pipeline:

```
App -> SurfaceFlinger -> HWC -> Samsung Display HAL -> mDNIe -> Panel
```

The mDNIe is the last stage before the panel. On custom ROMs, the driver is still in the kernel. The sysfs interface at `/sys/class/mdnie/mdnie/` provides direct control.

## Credits

- komori — Discovery, testing, and implementation

## License

CC-BY-NC-SA-4.0
