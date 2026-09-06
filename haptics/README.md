# Haptics

Samsung's haptic engine is accessible via sysfs at `/sys/devices/virtual/timed_output/vibrator/haptic_engine`.

## Status

Research phase — sysfs interface identified, need to map values and test.

## What's There

- **Haptic engine sysfs**: `/sys/devices/virtual/timed_output/vibrator/haptic_engine`
- **Vibrator sysfs**: `/sys/class/timed_output/vibrator/`

## How It Works

Samsung's haptic engine provides:
- Custom vibration patterns
- Intensity control
- Advanced haptic feedback for UI interactions

On LineageOS, the basic vibrator works but Samsung's advanced haptic patterns are not utilized.

## How to Explore

```bash
# Check haptic engine
adb shell su -c "ls -la /sys/devices/virtual/timed_output/vibrator/"

# Read haptic engine values
adb shell su -c "cat /sys/devices/virtual/timed_output/vibrator/haptic_engine"

# Check vibrator properties
adb shell su -c "cat /sys/class/timed_output/vibrator/enable"
adb shell su -c "cat /sys/class/timed_output/vibrator/voltages"
```

## Potential Features

1. **Custom vibration patterns** — Samsung's advanced patterns
2. **Intensity control** — Fine-grained vibration strength
3. **UI haptics** — Enhanced feedback for touch interactions

## License

CC-BY-NC-SA-4.0
