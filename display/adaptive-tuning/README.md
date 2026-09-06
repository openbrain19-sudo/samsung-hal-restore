# Adaptive Display Tuning

Samsung's mDNIe (mobile Digital Natural Image engine) controls display color profiles. On LineageOS, the mDNIe sysfs interface is accessible and fully functional — you just need root to control it.

## Status

**Working.** Tested on Samsung Galaxy S20 Ultra (SM-G988B) running LineageOS 23.2. The mDNIe sysfs at `/sys/class/mdnie/mdnie/` is accessible and responds to mode changes immediately.

## Available Modes

| Value | Mode | Description |
|-------|------|-------------|
| 0 | Dynamic | Oversaturated, high contrast |
| 1 | Standard | sRGB color accurate |
| 2 | Natural | Balanced, adaptive |
| 3 | Movie | DCI-P3, warm, cinematic |
| 4 | Auto | Samsung adaptive algorithm |

## Quick Start

### Windows

Run `switch-profile.bat` and select a mode (0-4).

### Linux/macOS

```bash
chmod +x switch-profile.sh
./switch-profile.sh        # interactive
./switch-profile.sh 3      # set Movie mode directly
```

### Manual ADB

```bash
# Check current mode
adb shell su -c "cat /sys/class/mdnie/mdnie/mdnie"

# Set to Movie (DCI-P3)
adb shell su -c "echo 3 > /sys/class/mdnie/mdnie/mode"

# Set to Standard (sRGB)
adb shell su -c "echo 1 > /sys/class/mdnie/mdnie/mode"

# Set to Dynamic
adb shell su -c "echo 0 > /sys/class/mdnie/mdnie/mode"
```

## Requirements

- ADB (Android SDK platform-tools)
- USB debugging enabled
- Root access (APatch or Magisk)
- Samsung Exynos device running LineageOS or custom ROM

## How It Works

Samsung's display pipeline:

```
App → SurfaceFlinger → HWC → Samsung Display HAL → mDNIe → Panel
```

The mDNIe is the last stage before the panel. It applies color transformations based on the current mode. On stock One UI, the Settings app writes to `/sys/class/mdnie/mdnie/mode` to change profiles.

On custom ROMs, the mDNIe driver is still in the kernel (it's part of the display driver). The sysfs interface is still there. Nobody just tried writing to it.

## Additional mDNIe Controls

```bash
# Check all mDNIe status
adb shell su -c "cat /sys/class/mdnie/mdnie/mdnie"

# Scenario modes (what type of content)
adb shell su -c "cat /sys/class/mdnie/mdnie/scenario"
# 0=ui, 1-3=video, 4=camera, 5=navi

# HDR mode
adb shell su -c "cat /sys/class/mdnie/mdnie/hdr"

# Night mode
adb shell su -c "cat /sys/class/mdnie/mdnie/night_mode"

# Bypass (disable mDNIe processing)
adb shell su -c "cat /sys/class/mdnie/mdnie/bypass"
```

## Persistence

The mDNIe mode resets to default on reboot. The scripts also write to `screen_mode_setting` in the Android settings database, which may persist across reboots depending on your ROM's init scripts.

For persistent mode, you could add the echo command to a boot script (e.g., `service.sh` in Magisk/APatch module).

## Troubleshooting

**Mode doesn't change colors:**
- Make sure you're running as root (`su -c`)
- Check that the write succeeded: `cat /sys/class/mdnie/mdnie/mdnie`
- Try opening Settings > Display and toggling something to force a refresh

**Permission denied:**
- Root is required for sysfs writes
- Make sure APatch/Magisk is installed and working

**Colors look wrong:**
- Set to Standard (1) for sRGB accurate colors
- Set to Natural (2) for a balanced profile
- The Dynamic and Movie modes are intentionally different from sRGB

## Technical Details

### mDNIe Sysfs Path

```
/sys/class/mdnie/mdnie/
├── mdnie          # Main status (read-only)
├── mode           # Display mode (read/write)
├── scenario       # Content scenario (read/write)
├── hdr            # HDR mode (read/write)
├── night_mode     # Blue light filter (read/write)
├── bypass         # Disable mDNIe (read/write)
├── accessibility  # Accessibility features
├── color_lens     # Color correction
└── power          # Power management
```

### Mode Values

| Value | Kernel Name | Description |
|-------|-------------|-------------|
| 0 | dynamic | Maximum saturation and contrast |
| 1 | standard | Standard sRGB color space |
| 2 | natural | Natural colors with adaptive tuning |
| 3 | movie | DCI-P3 wide color gamut |
| 4 | auto | Samsung's adaptive algorithm |

## Credits

- komori — Discovery, testing, and implementation
- Samsung — mDNIe kernel driver (still present in vendor partition)
- XDA community — Display research

## License

CC-BY-NC-SA-4.0
