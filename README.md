# Samsung HAL Restore

Restoring Samsung vendor HAL features on custom ROMs.

## The Problem

Samsung Exynos devices running LineageOS and other custom ROMs lose access to Samsung-specific hardware features. The common assumption is that these features "don't work" on custom ROMs. **This is wrong.** The vendor HAL is still there. The vendor keys are still accessible. Nobody just tried.

## What This Project Does

Proves that Samsung vendor features work on custom ROMs and builds tools to access them.

### Proven

- **Camera vendor keys** — All Samsung-specific camera2 vendor tags (beauty mode, HDR, scene optimization, etc.) work on custom ROMs. See [UltraCam](https://github.com/openbrain19-sudo/UltraCam) for the camera app that proves this.

### Proven (display)

- **Adaptive display tuning** — Samsung's mDNIe color profiles work on LineageOS. The sysfs interface at `/sys/class/mdnie/mdnie/mode` controls display modes directly. 5 profiles: Dynamic, Standard, Natural, Movie, Auto. See [display/adaptive-tuning](display/adaptive-tuning/) for scripts and details.

### In Progress

- **HDR10+ tone mapping** — mDNIe has an `hdr` sysfs entry. Need to map the values and enable HDR processing.

### Planned

- **Eye Comfort Shield** — Samsung's adaptive blue light filter. The mDNIe has a `night_mode` sysfs entry. Need to map values and enable it.
- **Dolby Atmos tuning** — Samsung's customized Dolby implementation on Exynos. Generic Dolby misses a lot of the Samsung-specific tuning.
- **UHQ Upscaler** — Samsung's proprietary DSP for wired headphone audio upsampling. Driver is there, interface needs reverse engineering.
- **Haptics** — Samsung's advanced vibration engine with custom patterns and intensities.

## How It Works

Samsung's vendor HAL lives on the vendor partition. When you flash a custom ROM, the vendor partition stays. The HAL blobs are still there. The vendor keys are still accessible through standard Android HAL interfaces (Camera2, Display, Audio, etc.).

The features don't "not work" — they just haven't been hooked up. This project hooks them up.

## Device Support

- Samsung Galaxy S20 Ultra (SM-G988B) — Exynos 990, codename z3s
- Likely works on other Exynos 990 devices (S20/S20+/Note 20 series)

## Credits

- **komori** — Discovery, testing, and implementation
- **ExtremeXT** — LineageOS for Exynos 990, kernel source
- **tdrkDev** — Samsung camera framework reverse engineering
- **illusion0001** — SamsungCamera research and APK samples

## License

CC-BY-NC-SA-4.0 — Use it, fork it, edit it. No selling. If you make it public, credit komori. If you make a derivative, it must be open source under the same license.
