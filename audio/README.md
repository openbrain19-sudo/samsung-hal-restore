# Audio HAL

Samsung's audio HAL for Exynos 990 (`audio.primary.universal990.so`) is present on the vendor partition. On custom ROMs, it runs generic audio processing instead of Samsung's custom tuning.

## Status

Research phase — HAL blob identified, need to reverse engineer Samsung-specific audio parameters.

## What's There

- **Audio HAL**: `audio.primary.universal990.so` in `/vendor/lib64/hw/`
- **Dolby**: `dax-default.xml` config + `dolby/` directory in `/vendor/etc/`
- **Samsung audio effects**: Present but not utilized on custom ROMs

## How It Works

Samsung's audio HAL applies custom processing for:
- Dolby Atmos tuning (Samsung-customized profiles)
- UHQ upscaler (wired headphone DSP)
- Samsung's equalizer presets
- Audio latency optimization

On LineageOS, the HAL is used for basic audio routing but Samsung's custom processing is skipped.

## Potential Features

1. **Dolby Atmos Samsung profiles** — access Samsung's custom Dolby tuning
2. **UHQ upscaler** — enable DSP for wired headphones
3. **Samsung equalizer** — access Samsung's custom EQ presets
4. **Audio latency** — Samsung's low-latency audio path

## How to Explore

```bash
# List audio HAL files
adb shell su -c "ls -la /vendor/lib64/hw/ | grep audio"

# Check Dolby config
adb shell su -c "cat /vendor/etc/dax-default.xml"

# Check Dolby directory
adb shell su -c "ls -la /vendor/etc/dolby/"

# Check audio effects
adb shell su -c "ls /vendor/lib64/soundfx/ 2>/dev/null"
```

## References

- Samsung audio HAL source (from kernel source drops)
- Dolby DAX documentation

## License

CC-BY-NC-SA-4.0
