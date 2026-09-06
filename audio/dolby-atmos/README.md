# Dolby Atmos Tuning

Samsung's customized Dolby implementation on Exynos. Generic Dolby on custom ROMs misses a lot of the Samsung-specific tuning and profiles.

## Status

Research phase — need to reverse engineer Samsung's Dolby HAL interface.

## How It Will Work

1. Find Samsung-specific Dolby parameters and profiles
2. Build interface to switch between tuning presets
3. Enable Samsung's custom Dolby Atmos modes

## References

- Dolby Atmos driver on vendor partition
- Samsung audio HAL source
