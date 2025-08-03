# VMAF Analyzer - Comprehensive Implementation Plan

## Project Overview
Building a native macOS app using SwiftUI for 8K video quality analysis, specifically designed for comparing Apple ProRes reference files against H.265 encoded videos with advanced visualization and progress tracking.

## Development Progress Tracking

### Completed Phases with Git Commits
- **✅ Phase 1.1** - Environment Setup (`9e4e8a9`) - Xcode project setup with comprehensive logging
- **✅ Phase 1.2** - Dependencies Integration (`38d481e`) - VMAF & FFmpeg integration with Swift wrappers
- **🚧 Phase 1.3** - Core Data Models (In Progress)
- **⏳ Phase 1.4** - File Type Validation System (Pending)
- **⏳ Phase 2.1** - File Selection Interface (Pending)
- **⏳ Phase 2.2** - Model Selection Interface (Pending)
- **⏳ Phase 2.3** - Basic UI Components (Pending)

### Current Status
- **Active Phase**: Phase 1 (Foundation & Setup)
- **Next Milestone**: Phase 2 (File Management & UI Foundation)
- **GitHub Repository**: https://github.com/lightsailvr/VMAF_Tester

## Architecture Overview

### Core Components
1. **File Management System** - ProRes/H.265 file handling with validation
2. **FFmpeg Integration** - Format conversion to VMAF-compatible formats
3. **VMAF Processing Engine** - Background analysis with progress tracking
4. **Results Visualization** - Interactive charts and detailed metrics display
5. **Export System** - Multiple format output support

### Technology Stack
- **UI Framework**: SwiftUI (macOS 14.0+)
- **Video Processing**: FFmpeg (bundled)
- **Quality Analysis**: VMAF binary (bundled)
- **Charts**: Swift Charts (for interactive graphs)
- **File Management**: Foundation + UniformTypeIdentifiers
- **Process Execution**: Foundation Process and Pipe classes

## Development Methodology

### Testing & Validation Approach
After each major feature implementation (numbered sections like 2.1, 2.2, etc.), we will:
1. **Build and run in Xcode** to verify compilation
2. **Execute comprehensive logging tests** to validate functionality
3. **Run manual testing scenarios** specific to that feature
4. **Review log output** to ensure expected behavior
5. **Fix any issues** before proceeding to the next feature
6. **Commit working code** with descriptive commit messages
7. **Push to GitHub repository** to maintain development history

### Logging Strategy
Implement comprehensive logging throughout the app using OSLog:
```swift
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let fileManager = Logger(subsystem: subsystem, category: "FileManager")
    static let conversion = Logger(subsystem: subsystem, category: "Conversion")
    static let vmafAnalysis = Logger(subsystem: subsystem, category: "VMAFAnalysis")
    static let ui = Logger(subsystem: subsystem, category: "UI")
    static let progress = Logger(subsystem: subsystem, category: "Progress")
}

// Usage examples:
Logger.fileManager.info("Selected ProRes file: \(url.path)")
Logger.conversion.debug("FFmpeg conversion started with parameters: \(params)")
Logger.vmafAnalysis.error("VMAF process failed: \(error.localizedDescription)")
```

## Phase 1: Foundation & Setup (Week 1)

### 1.1 Environment Setup
- [ ] Create Xcode project with macOS target (minimum macOS 12.0)
- [ ] Configure SwiftUI app structure with proper entitlements
- [ ] Set up project folder structure and documentation
- [ ] Implement comprehensive logging system with OSLog

**🧪 Test Checkpoint 1.1**: 
- Build and run empty app
- Verify logging system works
- Test app launches without errors
- Validate project structure is correct
- **Git Commit**: `9e4e8a9` - "✅ Phase 1.1 Complete: Xcode project setup with comprehensive logging"

### 1.2 Dependencies Integration
- [ ] Compile VMAF binary for macOS (Intel + Apple Silicon)
- [ ] Download and integrate FFmpeg static binaries
- [ ] Bundle both binaries in app Resources folder
- [ ] Create Swift wrappers for external tool execution
- [ ] Add extensive logging to tool execution wrappers

**🧪 Test Checkpoint 1.2**:
- Test VMAF binary execution with simple command
- Test FFmpeg binary execution with version check
- Verify binaries are correctly bundled in app
- Test Swift wrapper error handling
- Review logs for proper tool detection and execution
- **Git Commit**: `38d481e` - "✅ Phase 1.2 Complete: VMAF & FFmpeg Dependencies Integration"
- **Status**: ✅ PASSED (PARTIAL) - Binary discovery working, process execution needs sandboxing configuration

### 1.3 Core Data Models
```swift
// Video file representation
struct VideoFile {
    let url: URL
    let format: VideoFormat
    let codec: VideoCodec
    let resolution: VideoResolution
    let duration: TimeInterval
    let frameRate: Double
}

// VMAF analysis configuration
struct VMAFConfiguration {
    let model: VMAFModel
    let referenceFile: VideoFile
    let distortedFile: VideoFile
    let outputFormat: OutputFormat
}

// Analysis results
struct VMAFResults {
    let overallScore: Double
    let frameScores: [FrameScore]
    let additionalMetrics: AdditionalMetrics
    let processingStats: ProcessingStats
}
```

**🧪 Test Checkpoint 1.3**:
- Test data model initialization with sample data
- Verify model properties and relationships work correctly
- Test serialization/deserialization if applicable
- Review logs for proper model behavior
- **Git Commit**: [To be completed] - Phase 1.3 completion

### 1.4 File Type Validation System
- [ ] Create video format detection using AVFoundation
- [ ] Implement ProRes format validation
- [ ] Implement H.265 codec detection
- [ ] Create user-friendly error messaging system
- [ ] Add detailed logging for format detection process

**🧪 Test Checkpoint 1.4**:
- Test with sample ProRes files (various subtypes)
- Test with sample H.265 files (.mp4 and .mov containers)
- Test with unsupported formats (should fail gracefully)
- Verify error messages are user-friendly
- Review logs for accurate format detection
- Test edge cases: corrupted files, empty files, non-video files
- **Git Commit**: [To be completed] - Phase 1.4 completion

## Phase 2: File Management & UI Foundation (Week 2)

### 2.1 File Selection Interface
- [ ] Design main application window layout
- [ ] Implement native file picker for reference video (ProRes only)
- [ ] Implement native file picker for distorted video (H.265 in .mp4/.mov)
- [ ] Add drag-and-drop support with format validation
- [ ] Create file info display (resolution, duration, codec, file size)
- [ ] Add comprehensive logging for all file operations

**🧪 Test Checkpoint 2.1**:
- Test file picker with ProRes files (should succeed)
- Test file picker with non-ProRes files (should show error)
- Test drag-and-drop with valid files
- Test drag-and-drop with invalid files
- Verify file info displays correctly (resolution, codec, duration)
- Test with 8K files and verify performance
- Review logs for file selection events and validation results
- **Git Commit**: [To be completed] - Phase 2.1 completion

### 2.2 Model Selection Interface
- [ ] Design model selection dropdown with descriptions
- [ ] Implement model information tooltips
- [ ] Set vmaf_4k_v0.6.1 as default for 8K content
- [ ] Add model selection validation
- [ ] Add logging for model selection changes

**🧪 Test Checkpoint 2.2**:
- Test dropdown displays all available models
- Verify vmaf_4k_v0.6.1 is selected by default
- Test tooltip information displays correctly
- Test model selection persistence during app session
- Verify model descriptions are accurate and helpful
- Review logs for model selection events

### 2.3 Basic UI Components
```swift
// Main content view structure
struct ContentView: View {
    @StateObject private var analysisManager = VMAFAnalysisManager()
    
    var body: some View {
        VStack {
            FileSelectionView()
            ModelSelectionView()
            AnalysisControlView()
            ResultsDisplayView()
        }
    }
}
```
- [ ] Implement basic app layout structure
- [ ] Create placeholder views for all major components
- [ ] Add navigation and state management
- [ ] Implement basic styling following macOS guidelines
- [ ] Add logging for UI state changes

**🧪 Test Checkpoint 2.3**:
- Build and run app with complete UI structure
- Verify all views render correctly
- Test window resizing and layout adaptation
- Test basic navigation between UI components  
- Verify UI follows macOS design guidelines
- Review logs for UI initialization and state changes
- Test with different screen sizes and resolutions

## Phase 3: Format Conversion Pipeline (Week 3)

### 3.1 FFmpeg Integration
- [ ] Create FFmpeg wrapper class for Swift
- [ ] Implement ProRes to Y4M conversion
- [ ] Implement H.265 to Y4M conversion
- [ ] Add progress tracking for conversion process
- [ ] Handle fisheye/equirectangular projection preservation
- [ ] Add comprehensive logging for all FFmpeg operations

**🧪 Test Checkpoint 3.1**:
- Test ProRes to Y4M conversion with sample files
- Test H.265 to Y4M conversion with sample files
- Verify converted Y4M files are valid and playable
- Test conversion progress tracking accuracy
- Test projection format preservation
- Test with different ProRes variants (422, 4444, etc.)
- Test with different H.265 encoding settings
- Review logs for conversion parameters and results
- Test error handling for invalid input files

### 3.2 Temporary File Management
- [ ] Create secure temporary directory for converted files
- [ ] Implement automatic cleanup of temporary files
- [ ] Add disk space checking before conversion
- [ ] Handle large file processing (8K+ videos)
- [ ] Add logging for file management operations

**🧪 Test Checkpoint 3.2**:
- Verify temporary files are created in secure location
- Test automatic cleanup after successful conversion
- Test automatic cleanup after failed conversion
- Test disk space checking with various scenarios
- Test handling of very large 8K files (10+ GB)
- Verify proper file permissions on temporary files
- Review logs for file creation, usage, and cleanup
- Test concurrent file operations

### 3.3 Conversion Progress UI
- [ ] Add conversion progress indicators
- [ ] Display estimated conversion time
- [ ] Show current conversion step (ProRes → Y4M, H.265 → Y4M)
- [ ] Add cancellation capability for conversions
- [ ] Add logging for progress updates and user interactions

**🧪 Test Checkpoint 3.3**:
- Test progress indicators update correctly during conversion
- Verify time estimates become more accurate over time
- Test conversion step indicators change appropriately
- Test cancellation works at different stages of conversion
- Test UI remains responsive during long conversions
- Test progress accuracy with different file sizes
- Review logs for progress calculation and user actions
- Test multiple conversion scenarios back-to-back

## Phase 4: VMAF Analysis Engine (Week 4)

### 4.1 VMAF Process Management
```swift
class VMAFAnalysisManager: ObservableObject {
    @Published var progress: AnalysisProgress = .idle
    @Published var results: VMAFResults?
    
    func startAnalysis(config: VMAFConfiguration) async throws {
        // Convert files to Y4M format
        // Execute VMAF analysis
        // Parse results in real-time
        // Update progress continuously
    }
}
```
- [ ] Implement VMAFAnalysisManager class
- [ ] Add process execution and monitoring
- [ ] Implement background processing with async/await
- [ ] Add cancellation support for long-running analyses
- [ ] Add comprehensive logging for all analysis operations

**🧪 Test Checkpoint 4.1**:
- Test VMAF process starts correctly with converted Y4M files
- Test background processing doesn't block UI
- Test cancellation works at different stages of analysis
- Test process cleanup when cancelled or completed
- Test error handling for VMAF process failures
- Verify proper resource management for long-running processes
- Review logs for process lifecycle events
- Test with short sample videos first, then longer ones

### 4.2 Progress Tracking System
- [ ] Parse VMAF output for frame-by-frame progress
- [ ] Calculate processing speed (FPS)
- [ ] Estimate remaining time based on current speed
- [ ] Extract live VMAF scores as processing occurs
- [ ] Handle progress for very large files (8K, long duration)
- [ ] Add detailed logging for progress calculations

**🧪 Test Checkpoint 4.2**:
- Test frame-by-frame progress parsing accuracy
- Verify FPS calculations are correct and update in real-time
- Test time estimation accuracy improves over time
- Test live VMAF score extraction and display
- Test progress handling with various file sizes (1min to 30min+)
- Test progress accuracy with 8K content specifically
- Review logs for progress calculation methodology
- Test edge cases: very fast processing, very slow processing

### 4.3 Process Output Parsing
- [ ] Real-time JSON/XML parsing of VMAF output
- [ ] Extract frame-level scores for graphing
- [ ] Parse additional metrics (PSNR, SSIM, etc.)
- [ ] Handle parsing errors and incomplete data
- [ ] Add logging for all parsing operations and errors

**🧪 Test Checkpoint 4.3**:
- Test real-time parsing with sample VMAF output
- Verify frame-level data extraction is complete and accurate
- Test additional metrics parsing (PSNR, SSIM, MS-SSIM)
- Test error handling with malformed VMAF output
- Test parsing with incomplete data (interrupted process)
- Verify parsed data matches expected VMAF output format
- Review logs for parsing accuracy and error scenarios
- Test with various VMAF models and output formats

## Phase 5: Results Visualization (Week 5)

### 5.1 Primary Score Display
- [ ] Large, prominent VMAF score display
- [ ] Color-coded quality indicators:
  - Red: Poor (0-30)
  - Orange: Fair (30-60)
  - Yellow: Good (60-80)
  - Green: Excellent (80-100)
- [ ] Quality interpretation text
- [ ] Add logging for score display and user interactions

**🧪 Test Checkpoint 5.1**:
- Test score display with various VMAF values (0-100)
- Verify color coding changes appropriately for different score ranges
- Test score formatting and decimal precision
- Test quality interpretation text accuracy
- Test display with edge cases (very low/high scores)
- Verify accessibility compliance (VoiceOver, high contrast)
- Review logs for score display events
- Test responsive design with different window sizes

### 5.2 Interactive Per-Frame Graph
```swift
import Charts

struct VMAFScoreChart: View {
    let frameScores: [FrameScore]
    @State private var selectedFrame: FrameScore?
    
    var body: some View {
        Chart(frameScores) { frame in
            LineMark(
                x: .value("Time", frame.timestamp),
                y: .value("VMAF Score", frame.score)
            )
        }
        .chartOverlay { proxy in
            // Mouse tracking overlay
        }
    }
}
```

- [ ] Implement interactive line chart with Swift Charts
- [ ] Add mouse-over functionality for frame details
- [ ] Display timestamp and score on hover
- [ ] Add zoom and pan capabilities for long videos
- [ ] Correlate graph position with video timeline
- [ ] Add logging for chart interactions and performance

**🧪 Test Checkpoint 5.2**:
- Test chart rendering with various data sizes (100 frames to 10K+ frames)
- Test mouse-over functionality shows correct frame data
- Test timestamp and score display accuracy on hover
- Test zoom and pan operations work smoothly
- Test chart performance with 8K video data (high frame counts)
- Test chart responsiveness and smooth animations
- Test edge cases: single frame, missing data points
- Review logs for chart performance and interaction events
- Test accessibility features for chart navigation

### 5.3 Detailed Metrics View
- [ ] Expandable "More Details" section
- [ ] Display additional metrics (PSNR, SSIM, MS-SSIM)
- [ ] Show statistical data (min, max, mean, harmonic mean)
- [ ] Format metrics in user-friendly tables
- [ ] Add logging for detailed view interactions

**🧪 Test Checkpoint 5.3**:
- Test "More Details" expand/collapse functionality
- Verify all additional metrics display correctly
- Test statistical data accuracy (min, max, mean calculations)
- Test table formatting and readability
- Test with missing or incomplete metric data
- Test performance with large datasets
- Review logs for detailed view usage patterns
- Test copy/export functionality for metric data

## Phase 6: Progress Interface & Polish (Week 6)

### 6.1 Comprehensive Progress Display
```swift
struct AnalysisProgressView: View {
    let progress: AnalysisProgress
    
    var body: some View {
        VStack {
            ProgressView(value: progress.percentage)
            HStack {
                Text("Frame \(progress.currentFrame) of \(progress.totalFrames)")
                Spacer()
                Text("\(progress.fps, specifier: "%.1f") FPS")
            }
            HStack {
                Text("Current VMAF Score: \(progress.currentScore, specifier: "%.2f")")
                Spacer()
                Text("ETA: \(progress.estimatedTimeRemaining)")
            }
        }
    }
}
```
- [ ] Implement comprehensive progress display UI
- [ ] Add real-time updates for all progress elements
- [ ] Implement proper formatting for time and numerical displays
- [ ] Add logging for progress display performance and accuracy

**🧪 Test Checkpoint 6.1**:
- Test progress display with various analysis scenarios
- Verify all progress elements update correctly and in real-time
- Test percentage accuracy throughout entire analysis
- Test frame counter accuracy with different video lengths
- Test FPS calculation accuracy and stability
- Test ETA calculation and improvement over time
- Review logs for progress display performance
- Test UI layout with different progress states

### 6.2 Advanced Progress Features
- [ ] Real-time FPS calculation and display
- [ ] Estimated time remaining with accuracy improvement over time
- [ ] Current VMAF score preview during processing
- [ ] Processing stage indicators (Converting → Analyzing → Finalizing)
- [ ] Cancel button with confirmation dialog
- [ ] Add logging for all progress features and user interactions

**🧪 Test Checkpoint 6.2**:
- Test FPS calculation accuracy across different hardware
- Test ETA accuracy improvement over time (start vs. middle vs. end)
- Test current VMAF score preview updates correctly
- Test processing stage indicators change at appropriate times
- Test cancel button functionality at different stages
- Test confirmation dialog behavior and user choices
- Review logs for advanced progress feature performance
- Test with various processing speeds and file sizes

### 6.3 Error Handling & Recovery
- [ ] Comprehensive error detection and reporting
- [ ] Recovery suggestions for common issues
- [ ] Validation errors with correction guidance
- [ ] Processing errors with retry options
- [ ] Resource exhaustion warnings (disk space, memory)
- [ ] Add detailed logging for all error scenarios

**🧪 Test Checkpoint 6.3**:
- Test error detection for all anticipated failure scenarios
- Test error message clarity and helpfulness
- Test recovery suggestions lead to successful resolution
- Test retry functionality works correctly
- Test resource warning thresholds and accuracy
- Test error handling doesn't crash the app
- Review logs for comprehensive error tracking
- Test error scenarios: corrupted files, insufficient space, network issues

## Phase 7: Export & Final Features (Week 7)

### 7.1 Results Export System
- [ ] Export to JSON format (complete data)
- [ ] Export to XML format (VMAF standard)
- [ ] Export to CSV format (for spreadsheet analysis)
- [ ] Export chart as PNG/SVG image
- [ ] Batch export options
- [ ] Add logging for all export operations

**🧪 Test Checkpoint 7.1**:
- Test JSON export contains complete analysis data
- Test XML export follows VMAF standard format
- Test CSV export is properly formatted for spreadsheet use
- Test chart image export quality and formats
- Test batch export functionality with multiple results
- Test export with large datasets (8K, long duration analyses)
- Verify exported files can be opened by appropriate applications
- Review logs for export operation success and performance
- Test export error handling (write permissions, disk space)

### 7.2 Application Polish
- [ ] macOS design guideline compliance
- [ ] Accessibility features (VoiceOver, keyboard navigation)
- [ ] App icon and branding
- [ ] Help documentation and tooltips
- [ ] Preferences/settings panel
- [ ] Add logging for user interface interactions

**🧪 Test Checkpoint 7.2**:
- Verify app follows macOS Human Interface Guidelines
- Test accessibility features with VoiceOver and keyboard-only navigation
- Test app icon displays correctly in Finder and Dock
- Test all tooltips and help text for accuracy and clarity
- Test preferences panel functionality and persistence
- Test with different macOS appearance modes (light/dark)
- Review logs for UI interaction patterns
- Test app behavior across different macOS versions

### 7.3 Performance Optimization
- [ ] Memory management for large 8K files
- [ ] Efficient temporary file handling
- [ ] Background processing optimization
- [ ] UI responsiveness during heavy operations
- [ ] Add performance logging and monitoring

**🧪 Test Checkpoint 7.3**:
- Test memory usage with large 8K files (monitor Activity Monitor)
- Test temporary file cleanup and disk usage patterns
- Test UI remains responsive during heavy processing
- Test app performance with concurrent operations
- Test performance across different Mac hardware (Intel vs Apple Silicon)
- Review logs for performance bottlenecks and optimization opportunities
- Test app stability during extended use and multiple analyses
- Test performance with edge cases: very long videos, high frame rates

## Final Integration Testing

### 7.4 End-to-End Testing
- [ ] Complete workflow testing: file selection → conversion → analysis → results → export
- [ ] Test with real-world 8K ProRes and H.265 files
- [ ] Test all VMAF models with various content types
- [ ] Performance testing with production-sized files
- [ ] Multi-hour analysis testing for stability

**🧪 Final Test Checkpoint**:
- Complete end-to-end workflows with various file combinations
- Test entire app functionality with real 8K production files
- Verify all logging is comprehensive and useful for debugging
- Test app stability over extended periods (4+ hour analyses)
- Validate all requirements from original PRD are met
- Performance benchmarking and optimization verification
- User acceptance testing with target audience
- Final code review and documentation update

## Technical Challenges & Solutions

### Challenge 1: Large File Processing (8K Videos)
**Solution**: 
- Stream processing to avoid loading entire files in memory
- Efficient temporary file management with automatic cleanup
- Progress streaming to avoid UI blocking
- Memory pressure monitoring and warnings

### Challenge 2: FFmpeg Integration
**Solution**:
- Bundle static FFmpeg binaries for both Intel and Apple Silicon
- Create Swift wrapper with proper error handling
- Implement conversion progress tracking
- Handle different video container formats properly

### Challenge 3: Real-time Progress Tracking
**Solution**:
- Parse VMAF output stream in real-time using pipes
- Calculate processing statistics continuously
- Update UI on main thread using proper async patterns
- Handle variable processing speeds gracefully

### Challenge 4: Interactive Chart Performance
**Solution**:
- Use Swift Charts for native performance
- Implement data decimation for very long videos
- Optimize mouse tracking with debouncing
- Cache rendered chart elements

## Quality Assurance Plan

### Testing Strategy
1. **Unit Tests**: Core parsing and calculation logic
2. **Integration Tests**: FFmpeg and VMAF tool integration
3. **UI Tests**: User interaction flows
4. **Performance Tests**: Large file processing (8K, 60+ minutes)
5. **Compatibility Tests**: Different macOS versions and hardware

### Test Cases
- ProRes files from different cameras/encoders
- Various H.265 encoding settings and bitrates
- Different 8K resolutions and projection formats
- Edge cases: corrupted files, network interruptions, insufficient disk space
- Long-duration videos (2+ hours)
- Multiple concurrent analyses

## Deployment Plan

### App Distribution
- Direct distribution (not Mac App Store initially due to FFmpeg/VMAF dependencies)
- Code signing and notarization for macOS security
- Universal binary supporting Intel and Apple Silicon
- Installer package with proper permissions setup

### Documentation
- User manual with step-by-step instructions
- Technical documentation for advanced users
- Troubleshooting guide for common issues
- Video tutorials for complex workflows

## Timeline Summary
- **Week 1**: Foundation & Setup
- **Week 2**: File Management & UI Foundation  
- **Week 3**: Format Conversion Pipeline
- **Week 4**: VMAF Analysis Engine
- **Week 5**: Results Visualization
- **Week 6**: Progress Interface & Polish
- **Week 7**: Export & Final Features

**Total Estimated Development Time**: 7 weeks

This comprehensive plan addresses all the requirements while providing a structured approach to building a professional-grade VMAF analysis tool optimized for 8K video content.

## Git Commit Standards

### Commit Message Format
Each phase completion follows this commit message format:
```
✅ Phase X.Y Complete: [Feature Name]

🎯 PHASE X.Y - [Brief Description]
- [Key achievement 1]
- [Key achievement 2]
- [Key achievement 3]

🧪 TEST CHECKPOINT X.Y - [STATUS]
- ✅ [Successful test 1]
- ✅ [Successful test 2]
- ⚠️ [Partial success or note]

📊 TECHNICAL ACHIEVEMENTS:
- [Technical detail 1]
- [Technical detail 2]

🚀 Ready for Phase X.Y+1: [Next Phase Name]
✨ [Summary of readiness for next phase]
```

### Progress Tracking
- Each test checkpoint must have a corresponding git commit
- Commit messages include comprehensive details about what was accomplished
- All commits are pushed to the main branch on GitHub
- Progress is tracked both in this document and in git history
- Failed test checkpoints are documented with the issues found and resolution plans

### Repository Structure
- **Main Branch**: All development work and completed phases
- **Commit History**: Complete development timeline with detailed progress
- **GitHub Issues**: Track any blockers or complex problems that arise
- **Documentation**: Updated with each phase completion