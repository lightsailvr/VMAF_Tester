# VMAF Integration Analysis

## Current VMAF Installation Status

Based on exploration of `/Users/matthewcelia/vmaf/`, the repository contains:

### Available Components
1. **libvmaf**: C library with full API
2. **vmaf CLI tool**: Command-line interface (needs compilation)
3. **Python libraries**: Full featured Python implementation
4. **Built-in models**: Multiple VMAF models available
5. **Documentation**: Comprehensive usage guides

### Key Findings

#### VMAF Binary Status
- The `vmaf` binary is not currently compiled
- Need to build using: `meson setup build --buildtype release && ninja -vC build`
- Binary will be located at `build/tools/vmaf` after compilation

#### Supported Input Formats
- **Native**: .y4m (YUV4MPEG2) and .yuv (raw YUV)
- **Parameters required for .yuv**: width, height, pixel_format (420/422/444), bitdepth (8/10/12)
- **No built-in support** for common formats like .mp4, .mov, .avi

#### VMAF Models Available
Built-in models (no external files needed):
- `vmaf_v0.6.1` - Default general purpose model
- `vmaf_4k_v0.6.1` - Optimized for 4K content
- `vmaf_float_v0.6.1` - Floating-point version
- `vmaf_v0.6.1neg` - No Enhancement Gain mode
- Additional specialized models in `/model/` directory

#### Output Formats
- XML (default)
- JSON  
- CSV
- Subtitle format

#### Additional Metrics Available
- PSNR (Peak Signal-to-Noise Ratio)
- PSNR-HVS (Human Visual System weighted)
- SSIM (Structural Similarity Index)
- MS-SSIM (Multi-Scale SSIM)
- CIEDE2000 (color difference)
- CAMBI (banding detection)

## Integration Options for macOS App

### Option 1: Bundle Compiled VMAF Binary
**Approach**: Compile VMAF and bundle the binary with the app
- **Pros**: Self-contained, no external dependencies
- **Cons**: Increases app size, need to handle different architectures
- **Implementation**: Copy compiled binary to app bundle Resources

### Option 2: Use libvmaf C Library
**Approach**: Link against libvmaf and use C API directly
- **Pros**: Better performance, more control, smaller footprint
- **Cons**: More complex integration, need to handle C interop
- **Implementation**: Create Swift wrapper around libvmaf API

### Option 3: System Installation Requirement
**Approach**: Require users to install VMAF separately
- **Pros**: Simplest implementation
- **Cons**: Poor user experience, installation complexity
- **Implementation**: Check for vmaf binary in PATH

### Recommended Approach: Option 1 (Bundle Binary)
For the best user experience, we should bundle the compiled VMAF binary with the app.

## Command Line Interface Analysis

### Basic VMAF Usage
```bash
./vmaf \
  --reference reference_video.y4m \
  --distorted distorted_video.y4m \
  --model version=vmaf_v0.6.1 \
  --output results.xml
```

### For Raw YUV Files
```bash
./vmaf \
  --reference reference.yuv \
  --distorted distorted.yuv \
  --width 1920 --height 1080 --pixel_format 420 --bitdepth 8 \
  --model version=vmaf_v0.6.1 \
  --output results.json --json
```

### Output Parsing
The tool outputs structured data that includes:
- Per-frame scores for all metrics
- Pooled (aggregated) scores with statistics
- Processing metadata (fps, frame count, etc.)

Example JSON output structure:
```json
{
  "version": "e1d466c",
  "params": {
    "qualityWidth": 1920,
    "qualityHeight": 1080
  },
  "frames": [
    {
      "frameNum": 0,
      "metrics": {
        "vmaf": 85.123,
        "psnr_y": 34.567,
        // ... other metrics
      }
    }
  ],
  "pooled_metrics": {
    "vmaf": {
      "min": 71.2,
      "max": 87.1,
      "mean": 76.7,
      "harmonic_mean": 76.5
    }
  }
}
```

## Technical Requirements for macOS Integration

### Build Dependencies (for compiling VMAF)
- Python 3.6+
- Meson build system
- Ninja build tool  
- NASM (for x86 optimization)
- xxd utility

### Swift Integration Requirements
- Process execution for running VMAF binary
- JSON/XML parsing for results
- File system access for temporary files
- Progress monitoring for long-running processes

### Performance Considerations
- VMAF processing is CPU-intensive
- Large videos can take several minutes to process
- Need background processing to avoid UI blocking
- Memory usage scales with video resolution and length

## Compilation Steps for VMAF Binary

To prepare VMAF for bundling with the macOS app:

```bash
cd /Users/matthewcelia/vmaf
meson setup build --buildtype release
ninja -vC build
```

The compiled binary will be at: `build/tools/vmaf`

## Video Format Support Strategy

### Phase 1: Native Formats Only
- Support .y4m files (self-describing, easiest to handle)
- Support .yuv files with user-provided parameters
- Focus on core functionality

### Phase 2: Common Format Support (Future)
- Integrate FFmpeg for format conversion
- Convert input files to .y4m temporarily
- Support .mp4, .mov, .avi, .mkv, etc.

## Error Handling Considerations

### Common Error Scenarios
1. **Unsupported file formats**: Clear messaging about supported formats
2. **Missing reference video**: Prompt user to select reference
3. **Mismatched video parameters**: Validate resolution, format compatibility  
4. **Processing failures**: Parse VMAF error output and provide user-friendly messages
5. **Insufficient disk space**: Check for temporary file space requirements
6. **Corrupted video files**: Handle VMAF parsing errors gracefully

### Recovery Strategies
- Automatic parameter detection where possible
- Suggestions for common parameter values
- Links to documentation for advanced usage
- Retry mechanisms for transient failures