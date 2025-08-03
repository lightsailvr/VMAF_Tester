import SwiftUI
import OSLog

@main
struct VMAFAnalyzerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Logger.ui.info("VMAF Analyzer app launched successfully")
                    Logger.ui.debug("App version: 1.0, macOS deployment target: 14.0")
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
    }
}