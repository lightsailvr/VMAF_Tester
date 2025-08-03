import Foundation
import OSLog

/// Core VMAF analysis functionality with format conversion and progress tracking
class VMAFAnalyzer: ObservableObject {
    
    private let logger = Logger.vmafAnalysis
    private let processExecutor = ProcessExecutor()
    
    // MARK: - VMAF Models
    
    enum VMAFModel: String, CaseIterable {
        case vmaf_v0_6_1 = "vmaf_v0.6.1"
        case vmaf_4k_v0_6_1 = "vmaf_4k_v0.6.1"
        case vmaf_float_v0_6_1 = "vmaf_float_v0.6.1"
        
        var displayName: String {
            switch self {
            case .vmaf_v0_6_1:
                return "VMAF v0.6.1 (General Purpose)"
            case .vmaf_4k_v0_6_1:
                return "VMAF 4K v0.6.1 (Recommended for 8K)"
            case .vmaf_float_v0_6_1:
                return "VMAF Float v0.6.1 (High Precision)"
            }
        }
        
        var description: String {
            switch self {
            case .vmaf_v0_6_1:
                return "Standard VMAF model for general video quality assessment"
            case .vmaf_4k_v0_6_1:
                return "Optimized for 4K and 8K high-resolution content analysis"
            case .vmaf_float_v0_6_1:
                return "Floating-point version for maximum precision analysis"
            }
        }
        
        static var defaultFor8K: VMAFModel {
            return .vmaf_4k_v0_6_1
        }
    }
    
    // MARK: - Analysis Configuration
    
    struct AnalysisConfiguration {
        let referenceVideoPath: URL
        let distortedVideoPath: URL
        let model: VMAFModel
        let outputFormat: OutputFormat
        let outputPath: URL
        
        enum OutputFormat: String, CaseIterable {
            case json = "json"
            case xml = "xml"
            case csv = "csv"
            
            var fileExtension: String { rawValue }
        }
    }
    
    // MARK: - Video File Validation
    
    /// Validate that a video file is in ProRes format
    func validateProResFile(_ url: URL) async -> Bool {
        logger.info("🔍 Validating ProRes file: \(url.lastPathComponent)")
        
        let result = await processExecutor.executeFFmpeg(arguments: [
            "-i", url.path,
            "-f", "null",
            "-"
        ])
        
        let isProRes = result.stderr.contains("prores") || result.stderr.contains("ProRes")
        
        if isProRes {
            logger.success("✅ Confirmed ProRes format: \(url.lastPathComponent)")
        } else {
            logger.error("❌ File is not ProRes format: \(url.lastPathComponent)")
        }
        
        return isProRes
    }
    
    /// Validate that a video file is H.265 encoded
    func validateH265File(_ url: URL) async -> Bool {
        logger.info("🔍 Validating H.265 file: \(url.lastPathComponent)")
        
        let result = await processExecutor.executeFFmpeg(arguments: [
            "-i", url.path,
            "-f", "null",
            "-"
        ])
        
        let isH265 = result.stderr.contains("hevc") || result.stderr.contains("h265") || result.stderr.contains("H.265")
        
        if isH265 {
            logger.success("✅ Confirmed H.265 format: \(url.lastPathComponent)")
        } else {
            logger.error("❌ File is not H.265 format: \(url.lastPathComponent)")
        }
        
        return isH265
    }
    
    // MARK: - Format Conversion
    
    /// Convert ProRes or H.265 file to Y4M format for VMAF analysis
    /// - Parameters:
    ///   - inputPath: Path to input video file
    ///   - outputPath: Path for converted Y4M file
    /// - Returns: Success status
    func convertToY4M(inputPath: URL, outputPath: URL) async -> Bool {
        logger.info("🔄 Converting video to Y4M format")
        logger.info("📥 Input: \(inputPath.lastPathComponent)")
        logger.info("📤 Output: \(outputPath.lastPathComponent)")
        
        let timer = PerformanceTimer(operation: "Video conversion to Y4M")
        
        // FFmpeg command to convert to Y4M while preserving quality
        let arguments = [
            "-i", inputPath.path,           // Input file
            "-pix_fmt", "yuv420p",         // Pixel format compatible with VMAF
            "-f", "yuv4mpegpipe",          // Y4M output format
            "-y",                          // Overwrite output file
            outputPath.path                // Output file
        ]
        
        let result = await processExecutor.executeFFmpeg(arguments: arguments)
        timer.finish()
        
        if result.success {
            logger.success("✅ Video conversion completed successfully")
            
            // Check output file size
            if let attributes = try? FileManager.default.attributesOfItem(atPath: outputPath.path),
               let fileSize = attributes[.size] as? Int64 {
                logger.info("📊 Converted file size: \(ByteCountFormatter.string(fromByteCount: fileSize, countStyle: .file))")
            }
        } else {
            logger.failure("❌ Video conversion failed")
        }
        
        return result.success
    }
    
    // MARK: - VMAF Analysis
    
    /// Execute VMAF analysis on two Y4M files
    /// - Parameters:
    ///   - config: Analysis configuration
    /// - Returns: Success status
    func runVMAFAnalysis(config: AnalysisConfiguration) async -> Bool {
        logger.info("🎬 Starting VMAF analysis")
        logger.info("📊 Model: \(config.model.displayName)")
        logger.info("📄 Output format: \(config.outputFormat.rawValue.uppercased())")
        
        let timer = PerformanceTimer(operation: "VMAF analysis")
        
        // Create temporary directory for Y4M files
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("vmaf_analysis_\(UUID().uuidString)")
        
        do {
            try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
            logger.info("📁 Created temporary directory: \(tempDir.path)")
            
            let referenceY4M = tempDir.appendingPathComponent("reference.y4m")
            let distortedY4M = tempDir.appendingPathComponent("distorted.y4m")
            
            // Convert both videos to Y4M format
            logger.info("🔄 Converting reference video...")
            guard await convertToY4M(inputPath: config.referenceVideoPath, outputPath: referenceY4M) else {
                logger.error("❌ Failed to convert reference video")
                cleanup(tempDir: tempDir)
                return false
            }
            
            logger.info("🔄 Converting distorted video...")
            guard await convertToY4M(inputPath: config.distortedVideoPath, outputPath: distortedY4M) else {
                logger.error("❌ Failed to convert distorted video")
                cleanup(tempDir: tempDir)
                return false
            }
            
            // Run VMAF analysis
            let vmafArguments = [
                "--reference", referenceY4M.path,
                "--distorted", distortedY4M.path,
                "--model", "version=\(config.model.rawValue)",
                "--output", config.outputPath.path,
                "--\(config.outputFormat.rawValue)"
            ]
            
            logger.info("⚡ Executing VMAF analysis...")
            let result = await processExecutor.executeVMAF(arguments: vmafArguments)
            
            timer.finish()
            cleanup(tempDir: tempDir)
            
            if result.success {
                logger.success("✅ VMAF analysis completed successfully")
                logger.info("📊 Results saved to: \(config.outputPath.path)")
                return true
            } else {
                logger.failure("❌ VMAF analysis failed")
                return false
            }
            
        } catch {
            logger.failure("❌ Failed to create temporary directory", error: error)
            timer.finish()
            return false
        }
    }
    
    // MARK: - Utility Methods
    
    /// Clean up temporary files and directories
    private func cleanup(tempDir: URL) {
        do {
            try FileManager.default.removeItem(at: tempDir)
            logger.info("🗑️ Cleaned up temporary directory")
        } catch {
            logger.error("⚠️ Failed to cleanup temporary directory: \(error.localizedDescription)")
        }
    }
    
    /// Verify all dependencies are available
    func verifyDependencies() async -> Bool {
        logger.info("🔍 Verifying VMAF analysis dependencies...")
        return await processExecutor.verifyBinaries()
    }
    
    /// Get estimated analysis time based on video duration and resolution
    func estimateAnalysisTime(videoDuration: TimeInterval, resolution: String) -> TimeInterval {
        // Rough estimation based on typical VMAF performance
        // This is a placeholder - actual timing will vary significantly
        let baseTime = videoDuration * 0.1 // 10% of video duration as base
        
        let resolutionMultiplier: Double
        switch resolution.lowercased() {
        case let res where res.contains("8k") || res.contains("7680"):
            resolutionMultiplier = 8.0
        case let res where res.contains("4k") || res.contains("3840"):
            resolutionMultiplier = 4.0
        case let res where res.contains("1080"):
            resolutionMultiplier = 1.0
        default:
            resolutionMultiplier = 0.5
        }
        
        return baseTime * resolutionMultiplier
    }
}