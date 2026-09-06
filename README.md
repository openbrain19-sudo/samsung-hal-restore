# Samsung HAL Restore

Restoring Samsung vendor HAL features on custom ROMs.

## The Problem

Samsung Exynos devices running LineageOS and other custom ROMs lose access to Samsung-specific hardware features. The common assumption is that these features "don't work" on custom ROMs. **This is wrong.** The vendor HAL is still there. The vendor keys are still accessible. Nobody just tried.

## What This Project Does

Proves that Samsung vendor features work on custom ROMs and builds tools to access them.

### Proven

- **Camera vendor keys** — All Samsung-specific camera2 vendor tags (beauty mode, HDR, scene optimization, etc.) work on custom ROMs. See [UltraCam](https://github.com/openbrain19-sudo/UltraCam) for the camera app that proves this.

### In Progress

- **Adaptive display tuning** — Samsung's color profiles (Natural/Vivid/Adaptive) are vendor-specific. The display HAL supports it, just needs the right metadata written.

### Planned

- **HDR10+ tone mapping** — Samsung's HDR10+ metadata and display pipeline. Hardware supports it, pipeline is skipped on custom ROMs.
- **Eye Comfort Shield** — Samsung's adaptive blue light filter. Smarter than the generic Android implementation.
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

MIT
