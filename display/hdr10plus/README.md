# HDR10+ Tone Mapping

Samsung's HDR10+ metadata and display pipeline. The hardware supports HDR10+ tone mapping but the pipeline is skipped on custom ROMs.

## Status

Research phase — need to identify the vendor keys and HAL interface.

## How It Will Work

1. Find HDR10+ vendor keys in Samsung's display HAL
2. Hook into the tone mapping pipeline
3. Enable HDR10+ content playback with proper tone mapping

## References

- HDR10+ standard documentation
- Samsung display HAL source
