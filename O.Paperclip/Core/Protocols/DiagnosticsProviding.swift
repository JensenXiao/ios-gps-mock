import Foundation
import SwiftUI

@MainActor
protocol DiagnosticsProviding: AnyObject {
    var lastUnexpectedTermination: UnexpectedTerminationRecord? { get }
    var logsDirectoryURL: URL { get }
    func setupIfNeeded()
    func noteScenePhase(_ phase: ScenePhase)
    func openLogsDirectory()
}
