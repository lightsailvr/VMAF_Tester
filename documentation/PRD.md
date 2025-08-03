# macOS VMAF GUI App - Product Requirements Document

## Overview
Create a native macOS application using SwiftUI that provides an intuitive graphical user interface for Netflix's VMAF (Video Multi-Method Assessment Fusion) video quality assessment tool. The app will allow users to easily analyze video quality without needing command-line expertise.

## Background
VMAF is an Emmy-winning perceptual video quality assessment algorithm developed by Netflix. It's currently available as:
- A command-line tool (`vmaf`) that processes .y4m and .yuv video files
- A C library (`libvmaf`) with various built-in models
- Python libraries and scripts for advanced usage

The goal is to make this powerful tool accessible to users who prefer a graphical interface.

## Requirements (Based on Stakeholder Input)

### 1. Video Format Support - DECIDED
**Decision**: Support Apple ProRes files and H.265 encoded files (.mp4/.mov containers)
- **Reference video**: Apple ProRes format (high quality reference)
- **Distorted video**: H.265 encoded file in .mp4 or .mov container
- **Implementation**: Requires FFmpeg integration for format conversion to VMAF-compatible formats
- **Priority**: Core feature - must be included in V1

### 2. Target Use Case - DECIDED  
**Decision**: Optimized for large 8K files with fisheye or equirectangular projection formats
- **Video characteristics**: 8K resolution, specialized projection formats
- **Performance considerations**: Large file processing, extended analysis times
- **Model selection**: Need appropriate model for 8K content analysis

### 3. VMAF Model Selection - DECIDED
**Decision**: User selection with smart defaults and descriptive UI guidance
- **Default model**: `vmaf_4k_v0.6.1` (best for 8K content analysis)
- **UI approach**: Dropdown with model descriptions and use case guidance
- **Models to include**:
  - `vmaf_4k_v0.6.1` - Recommended for 8K/4K content (default)
  - `vmaf_v0.6.1` - General purpose model
  - `vmaf_float_v0.6.1` - High precision floating-point version
- **Help text**: Clear descriptions of when to use each model

### 4. Results Display - DECIDED
**Decision**: Main VMAF score with expandable detailed view and interactive per-frame graph
- **Primary display**: Large, prominent VMAF score
- **Secondary display**: "More Details" button revealing additional metrics (PSNR, SSIM, etc.)
- **Advanced visualization**: Interactive per-frame graph with:
  - Mouse-over capability to see frame-specific scores
  - Time-based navigation to identify compression artifacts
  - Visual correlation between image complexity and quality scores
- **Export capability**: Full results in JSON/XML/CSV formats

### 5. Processing Feedback - DECIDED
**Decision**: Comprehensive progress indication (Option E - All of the above)
- **Progress bar**: Visual completion percentage
- **Frame progress**: "Processing frame X of Y"
- **Processing speed**: Real-time FPS indicator
- **Time estimates**: Estimated time remaining based on current processing speed
- **Current score**: Live preview of VMAF score as frames are processed
- **Cancellation**: Ability to stop processing at any time

## Core Requirements

### Functional Requirements

#### File Management
- **FR-1**: Users must be able to select Apple ProRes reference files and H.265 distorted files (.mp4/.mov) using native macOS file picker
- **FR-2**: App must support drag-and-drop for video files with automatic format detection
- **FR-3**: App must validate that reference files are ProRes format and distorted files are H.265 encoded
- **FR-4**: App must provide clear error messages for unsupported formats with guidance on correct formats
- **FR-5**: App must handle large 8K video files (multi-GB file sizes) efficiently

#### Format Conversion & Processing
- **FR-6**: App must integrate FFmpeg to convert ProRes and H.265 files to VMAF-compatible formats (.y4m)
- **FR-7**: App must preserve video quality during format conversion process
- **FR-8**: App must handle fisheye and equirectangular projection formats correctly
- **FR-9**: App must execute VMAF analysis using the compiled VMAF binary
- **FR-10**: App must process videos in background without blocking UI
- **FR-11**: App must support cancellation of long-running analysis operations

#### Model Selection & Configuration
- **FR-12**: App must provide VMAF model selection with smart defaults (vmaf_4k_v0.6.1 for 8K content)
- **FR-13**: App must display descriptive text for each model to guide user selection
- **FR-14**: App must include models: vmaf_4k_v0.6.1, vmaf_v0.6.1, vmaf_float_v0.6.1
- **FR-15**: App must auto-detect video parameters (resolution, framerate) from input files

#### Results Display & Visualization
- **FR-16**: App must prominently display the final pooled VMAF score in large, readable format
- **FR-17**: App must provide quality interpretation with color-coded indicators
- **FR-18**: App must include "More Details" expandable section with additional metrics (PSNR, SSIM, etc.)
- **FR-19**: App must display interactive per-frame graph with mouse-over capability
- **FR-20**: App must allow time-based navigation to correlate scores with video content
- **FR-21**: App must export complete results to JSON, XML, and CSV formats

#### Processing Feedback & Progress
- **FR-22**: App must display comprehensive progress indication including:
  - Visual progress bar with percentage completion
  - Frame progress counter ("Processing frame X of Y")
  - Real-time processing speed (FPS)
  - Estimated time remaining
  - Live preview of current VMAF score
- **FR-23**: App must provide immediate feedback for all user interactions
- **FR-24**: App must handle processing errors gracefully with recovery options

### Non-Functional Requirements

#### Performance
- **NFR-1**: App startup time must be under 3 seconds
- **NFR-2**: File selection and validation must be near-instantaneous
- **NFR-3**: VMAF processing performance must match CLI tool performance

#### Compatibility
- **NFR-4**: App must support macOS 12.0+ (for modern SwiftUI features)
- **NFR-5**: App must work with existing VMAF installation or bundle VMAF binary

#### Usability
- **NFR-6**: Users with no VMAF experience should be able to get results within 2 minutes
- **NFR-7**: All user actions should provide immediate feedback
- **NFR-8**: Error messages should be user-friendly and actionable

## Technical Architecture

### Components
1. **UI Layer**: SwiftUI-based interface
2. **File Management**: Native file picker and validation
3. **VMAF Integration**: Process execution and output parsing
4. **Results Processing**: Score calculation and formatting
5. **Export System**: Multiple format output support

### Dependencies
- **macOS SDK**: For native file picker and system integration
- **VMAF Binary**: Either bundled or system-installed
- **Foundation**: For process execution and file management
- **SwiftUI**: For modern, declarative UI

## Success Criteria

### Primary Success Metrics
- Users can successfully analyze video quality with zero command-line knowledge
- 95% of analyses complete successfully on supported formats
- Average time from file selection to results under 5 minutes for typical videos

### Secondary Success Metrics  
- Users find the interface intuitive (measured via usability testing)
- Error recovery is successful in 90% of error cases
- Export functionality works reliably across all supported formats

## Future Enhancements (Out of Scope for V1)
- Batch processing of multiple video pairs
- Advanced visualization (graphs, charts, frame-by-frame analysis)
- Integration with cloud storage services
- Custom model training interface
- Video format conversion with FFmpeg integration
- Results comparison and history tracking

## Questions for Stakeholder Review
Please review the clarifying questions above and provide direction on:
1. Reference video handling approach
2. Video format support strategy  
3. Model selection complexity level
4. Results detail level preference
5. Processing feedback requirements

These decisions will significantly impact the development approach and user experience design.