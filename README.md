# VMAF Analyzer

A native macOS application built with SwiftUI for analyzing video quality using Netflix's VMAF (Video Multi-Method Assessment Fusion) algorithm. Specifically designed for comparing Apple ProRes reference files against H.265 encoded videos, with support for 8K content and fisheye/equirectangular projections.

## Features

### 🎯 Core Functionality
- **Video Format Support**: Apple ProRes reference files and H.265 encoded videos (.mp4/.mov)
- **8K Optimization**: Designed for large 8K video files with specialized projection formats
- **VMAF Models**: Smart defaults with user selection (vmaf_4k_v0.6.1 recommended for 8K content)
- **Real-time Progress**: Comprehensive progress tracking with FPS, frame counts, and ETA
- **Interactive Visualization**: Per-frame VMAF score graphs with mouse-over details

### 📊 Results & Export
- **Primary Score Display**: Large, color-coded VMAF score with quality interpretation
- **Detailed Metrics**: Expandable view with PSNR, SSIM, MS-SSIM, and statistical data
- **Multiple Export Formats**: JSON, XML, CSV, and chart image exports
- **Interactive Charts**: Time-based navigation to correlate scores with video content

### 🔧 Technical Features
- **Background Processing**: Non-blocking analysis with cancellation support
- **Format Conversion**: Automatic FFmpeg integration for ProRes/H.265 to Y4M conversion
- **Comprehensive Logging**: Detailed OSLog integration for debugging and validation
- **Error Handling**: Graceful error recovery with actionable user guidance

## Requirements

- **macOS**: 12.0+ (for modern SwiftUI features)
- **Hardware**: Recommended for Apple Silicon Macs (optimized performance)
- **Dependencies**: FFmpeg and VMAF binaries (bundled with app)

## Project Structure

```
VMAF_Tester/
├── documentation/           # Project documentation
│   ├── PRD.md              # Product Requirements Document
│   ├── VMAF_Analysis.md    # Technical analysis of VMAF integration
│   └── Implementation_Plan.md # Comprehensive 7-week development plan
├── src/                    # Source code (to be created)
├── resources/              # App resources and bundled binaries
└── tests/                  # Test files and scenarios
```

## Development Plan

This project follows a **7-week phased development approach** with comprehensive testing at each stage:

- **Week 1**: Foundation & Setup (Xcode project, VMAF/FFmpeg integration)
- **Week 2**: File Management & UI Foundation
- **Week 3**: Format Conversion Pipeline
- **Week 4**: VMAF Analysis Engine
- **Week 5**: Results Visualization
- **Week 6**: Progress Interface & Polish
- **Week 7**: Export & Final Features

Each phase includes detailed **test checkpoints** to ensure functionality is validated before proceeding.

## Getting Started

### Prerequisites
1. Xcode 14.0+ with SwiftUI support
2. macOS 12.0+ development target
3. Access to sample ProRes and H.265 video files for testing

### Setup
1. Clone this repository
2. Follow the implementation plan in `documentation/Implementation_Plan.md`
3. Begin with Phase 1: Foundation & Setup

## Contributing

This project follows a test-driven development approach with:
- Comprehensive logging using OSLog
- Build and run verification after each major feature
- Manual testing scenarios for each implementation phase
- Code commit requirements with descriptive messages

## Technical Architecture

- **UI Framework**: SwiftUI (native macOS)
- **Video Processing**: FFmpeg (format conversion)
- **Quality Analysis**: VMAF binary (Netflix's algorithm)
- **Charts**: Swift Charts (interactive visualization)
- **Process Management**: Foundation Process and Pipe classes

## License

[License information to be added]

## Acknowledgments

- Netflix for the VMAF algorithm and implementation
- FFmpeg project for video processing capabilities
- Apple for SwiftUI and macOS development frameworks

---

**Status**: 🚧 In Development - Phase 1 (Foundation & Setup)

For detailed technical information, see the documentation folder.