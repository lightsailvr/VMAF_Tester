import Foundation
import OSLog

/// Handles execution of external processes (VMAF, FFmpeg) with comprehensive logging and error handling
class ProcessExecutor: ObservableObject {
    
    private let logger = Logger.process
    
    // MARK: - Process Execution Result
    
    struct ProcessResult {
        let exitCode: Int32
        let stdout: String
        let stderr: String
        let executionTime: TimeInterval
        let success: Bool
        
        init(exitCode: Int32, stdout: String, stderr: String, executionTime: TimeInterval) {
            self.exitCode = exitCode
            self.stdout = stdout
            self.stderr = stderr
            self.executionTime = executionTime
            self.success = exitCode == 0
        }
    }
    
    // MARK: - Binary Paths
    
    /// Get the path to the VMAF binary (bundled or system)
    var vmafBinaryPath: URL? {
        // Try bundled binary first
        if let resourcePath = Bundle.main.resourceURL?.appendingPathComponent("bin/vmaf"),
           FileManager.default.fileExists(atPath: resourcePath.path) {
            logger.info("✅ Located bundled VMAF binary at: \(resourcePath.path)")
            return resourcePath
        }
        
        // Fall back to system binary
        if let systemPath = findSystemBinary(name: "vmaf") {
            logger.info("✅ Located system VMAF binary at: \(systemPath.path)")
            return systemPath
        }
        
        // Try the compiled VMAF binary we created
        let compiledVMAFPath = URL(fileURLWithPath: "/Users/matthewcelia/vmaf/libvmaf/build/tools/vmaf")
        if FileManager.default.fileExists(atPath: compiledVMAFPath.path) {
            logger.info("✅ Located compiled VMAF binary at: \(compiledVMAFPath.path)")
            return compiledVMAFPath
        }
        
        logger.error("❌ VMAF binary not found in bundle, system PATH, or compiled location")
        return nil
    }
    
    /// Get the path to the FFmpeg binary (bundled or system)
    var ffmpegBinaryPath: URL? {
        // Try bundled binary first
        if let resourcePath = Bundle.main.resourceURL?.appendingPathComponent("bin/ffmpeg"),
           FileManager.default.fileExists(atPath: resourcePath.path) {
            logger.info("✅ Located bundled FFmpeg binary at: \(resourcePath.path)")
            return resourcePath
        }
        
        // Fall back to system binary
        if let systemPath = findSystemBinary(name: "ffmpeg") {
            logger.info("✅ Located system FFmpeg binary at: \(systemPath.path)")
            return systemPath
        }
        
        logger.error("❌ FFmpeg binary not found in bundle or system PATH")
        return nil
    }
    
    /// Find a binary in the system PATH
    private func findSystemBinary(name: String) -> URL? {
        let task = Process()
        task.launchPath = "/usr/bin/which"
        task.arguments = [name]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        do {
            try task.run()
            task.waitUntilExit()
            
            if task.terminationStatus == 0 {
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let path = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
                   !path.isEmpty {
                    return URL(fileURLWithPath: path)
                }
            }
        } catch {
            logger.debug("Failed to search for \(name) in PATH: \(error)")
        }
        
        return nil
    }
    
    // MARK: - Process Execution
    
    /// Execute a process with the given executable and arguments
    /// - Parameters:
    ///   - executablePath: Path to the executable
    ///   - arguments: Command line arguments
    ///   - workingDirectory: Working directory for the process
    ///   - environment: Environment variables (nil uses inherited environment)
    /// - Returns: ProcessResult containing execution details
    func executeProcess(
        executablePath: URL,
        arguments: [String] = [],
        workingDirectory: URL? = nil,
        environment: [String: String]? = nil
    ) async -> ProcessResult {
        
        let timer = PerformanceTimer(operation: "Process execution: \(executablePath.lastPathComponent)")
        logger.info("🚀 Starting process: \(executablePath.lastPathComponent)")
        logger.debug("📋 Arguments: \(arguments.joined(separator: " "))")
        
        let process = Process()
        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        
        // Configure process
        process.executableURL = executablePath
        process.arguments = arguments
        process.standardOutput = stdoutPipe
        process.standardError = stderrPipe
        
        if let workingDirectory = workingDirectory {
            process.currentDirectoryURL = workingDirectory
            logger.debug("📁 Working directory: \(workingDirectory.path)")
        }
        
        if let environment = environment {
            process.environment = environment
            logger.debug("🌍 Custom environment variables: \(environment.keys.joined(separator: ", "))")
        }
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        do {
            try process.run()
            logger.info("▶️ Process started successfully (PID: \(process.processIdentifier))")
            
            // Wait for completion
            process.waitUntilExit()
            
            let endTime = CFAbsoluteTimeGetCurrent()
            let executionTime = endTime - startTime
            
            // Collect output
            let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
            let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
            
            let stdout = String(data: stdoutData, encoding: .utf8) ?? ""
            let stderr = String(data: stderrData, encoding: .utf8) ?? ""
            
            let result = ProcessResult(
                exitCode: process.terminationStatus,
                stdout: stdout,
                stderr: stderr,
                executionTime: executionTime
            )
            
            // Log results
            if result.success {
                logger.success("Process completed successfully")
                logger.timing("Process execution", duration: executionTime)
            } else {
                logger.failure("Process failed with exit code: \(result.exitCode)")
                if !stderr.isEmpty {
                    logger.error("❌ Process stderr: \(stderr)")
                }
            }
            
            if !stdout.isEmpty {
                logger.debug("📤 Process stdout: \(stdout.prefix(500))..") // Truncate long output for logs
            }
            
            timer.finish()
            return result
            
        } catch {
            let executionTime = CFAbsoluteTimeGetCurrent() - startTime
            logger.failure("Failed to start process", error: error)
            timer.finish()
            
            return ProcessResult(
                exitCode: -1,
                stdout: "",
                stderr: "Failed to start process: \(error.localizedDescription)",
                executionTime: executionTime
            )
        }
    }
    
    // MARK: - Convenience Methods
    
    /// Execute VMAF with the given arguments
    func executeVMAF(arguments: [String]) async -> ProcessResult {
        guard let vmafPath = vmafBinaryPath else {
            return ProcessResult(
                exitCode: -1,
                stdout: "",
                stderr: "VMAF binary not found in app bundle",
                executionTime: 0
            )
        }
        
        logger.info("🎬 Executing VMAF analysis")
        return await executeProcess(executablePath: vmafPath, arguments: arguments)
    }
    
    /// Execute FFmpeg with the given arguments
    func executeFFmpeg(arguments: [String]) async -> ProcessResult {
        guard let ffmpegPath = ffmpegBinaryPath else {
            return ProcessResult(
                exitCode: -1,
                stdout: "",
                stderr: "FFmpeg binary not found in app bundle",
                executionTime: 0
            )
        }
        
        logger.info("🎞️ Executing FFmpeg conversion")
        return await executeProcess(executablePath: ffmpegPath, arguments: arguments)
    }
    
    // MARK: - Binary Verification
    
    /// Verify that both VMAF and FFmpeg binaries are available and executable
    func verifyBinaries() async -> Bool {
        logger.info("🔍 Verifying bundled binaries...")
        
        // Test VMAF
        let vmafResult = await executeVMAF(arguments: ["--version"])
        guard vmafResult.success else {
            logger.error("❌ VMAF binary verification failed")
            return false
        }
        
        // Test FFmpeg  
        let ffmpegResult = await executeFFmpeg(arguments: ["-version"])
        guard ffmpegResult.success else {
            logger.error("❌ FFmpeg binary verification failed")
            return false
        }
        
        logger.success("✅ All binaries verified successfully")
        logger.info("📊 VMAF version: \(vmafResult.stdout.trimmingCharacters(in: .whitespacesAndNewlines))")
        logger.info("🎞️ FFmpeg version: \(ffmpegResult.stdout.components(separatedBy: "\n").first ?? "unknown")")
        
        return true
    }
}