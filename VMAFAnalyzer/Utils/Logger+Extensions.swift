import OSLog
import Foundation

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    // MARK: - Logging Categories
    
    /// File management operations (selection, validation, format detection)
    static let fileManager = Logger(subsystem: subsystem, category: "FileManager")
    
    /// Video format conversion operations (FFmpeg integration)
    static let conversion = Logger(subsystem: subsystem, category: "Conversion")
    
    /// VMAF analysis operations (process execution, progress tracking)
    static let vmafAnalysis = Logger(subsystem: subsystem, category: "VMAFAnalysis")
    
    /// User interface events and state changes
    static let ui = Logger(subsystem: subsystem, category: "UI")
    
    /// Progress tracking and performance monitoring
    static let progress = Logger(subsystem: subsystem, category: "Progress")
    
    /// Process execution and external tool integration
    static let process = Logger(subsystem: subsystem, category: "Process")
    
    /// Error handling and recovery operations
    static let error = Logger(subsystem: subsystem, category: "Error")
    
    // MARK: - Convenience Methods
    
    /// Log successful operation completion
    func success(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        self.info("✅ SUCCESS [\(fileName):\(line) \(function)] \(message)")
    }
    
    /// Log operation failure with context
    func failure(_ message: String, error: Error? = nil, function: String = #function, file: String = #file, line: Int = #line) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let errorInfo = error?.localizedDescription ?? "No error details"
        self.error("❌ FAILURE [\(fileName):\(line) \(function)] \(message) - Error: \(errorInfo)")
    }
    
    /// Log performance timing information
    func timing(_ operation: String, duration: TimeInterval, function: String = #function) {
        self.info("⏱️ TIMING [\(function)] \(operation) completed in \(String(format: "%.3f", duration))s")
    }
    
    /// Log user actions for analytics
    func userAction(_ action: String, context: [String: Any] = [:]) {
        let contextString = context.isEmpty ? "" : " - Context: \(context)"
        self.info("👤 USER_ACTION: \(action)\(contextString)")
    }
}

// MARK: - Performance Timing Helper

class PerformanceTimer {
    private let startTime: CFAbsoluteTime
    private let operation: String
    private let logger: Logger
    
    init(operation: String, logger: Logger = Logger.progress) {
        self.operation = operation
        self.logger = logger
        self.startTime = CFAbsoluteTimeGetCurrent()
        logger.debug("🚀 STARTED: \(operation)")
    }
    
    func finish() {
        let duration = CFAbsoluteTimeGetCurrent() - startTime
        logger.timing(operation, duration: duration)
    }
}

// MARK: - Structured Logging for Complex Operations

extension Logger {
    /// Log file operation with structured data
    func fileOperation(
        _ operation: String,
        file: URL,
        size: Int64? = nil,
        format: String? = nil,
        success: Bool = true
    ) {
        let sizeInfo = size.map { " (\(ByteCountFormatter.string(fromByteCount: $0, countStyle: .file)))" } ?? ""
        let formatInfo = format.map { " [\($0)]" } ?? ""
        let status = success ? "✅" : "❌"
        
        if success {
            self.info("\(status) FILE_OP: \(operation) - \(file.lastPathComponent)\(sizeInfo)\(formatInfo)")
        } else {
            self.error("\(status) FILE_OP: \(operation) - \(file.lastPathComponent)\(sizeInfo)\(formatInfo)")
        }
    }
    
    /// Log process execution with structured data
    func processExecution(
        _ command: String,
        arguments: [String] = [],
        success: Bool = true,
        exitCode: Int32? = nil
    ) {
        let argInfo = arguments.isEmpty ? "" : " with args: \(arguments.joined(separator: " "))"
        let exitInfo = exitCode.map { " (exit: \($0))" } ?? ""
        let status = success ? "✅" : "❌"
        
        if success {
            self.info("\(status) PROCESS: \(command)\(argInfo)\(exitInfo)")
        } else {
            self.error("\(status) PROCESS: \(command)\(argInfo)\(exitInfo)")
        }
    }
}