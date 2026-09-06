# Adaptive Display Tuning

Samsung's color profiles (Natural/Vivid/Adaptive) are vendor-specific display settings that work through the display HAL. The HAL is there on custom ROMs, just needs the right metadata.

## Status

Research phase — reverse engineering Samsung's display HAL vendor keys.

## How It Will Work

1. Identify vendor keys for color profile switching
2. Build a simple app or script that writes the right metadata
3. Toggle between Natural/Vivid/Adaptive on demand

## References

- Samsung display HAL source (from kernel source drops)
- Adaptive display settings in One UI
