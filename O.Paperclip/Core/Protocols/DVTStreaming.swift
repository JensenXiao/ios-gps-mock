import Foundation

protocol DVTStreaming: AnyObject {
    var isRunning: Bool { get }
    func start(
        host: String,
        port: String,
        onOutput: @escaping @Sendable (String) -> Void,
        onError: @escaping @Sendable (String) -> Void,
        onExit: @escaping @Sendable (Int32) -> Void
    ) throws
    func send(latitude: Double, longitude: Double) throws
    func clear()
    func stop()
}
