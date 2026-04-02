import SwiftUI
import MapKit

// A lightweight wrapper to host map-related content.
// This keeps the map area as a separate composable, allowing ContentView
// to remain a top-level composer while preserving exact UI/behavior.
public struct MapContentView<Content: View>: View {
    @Binding public var cameraPosition: MapCameraPosition
    public let content: Content

    public init(cameraPosition: Binding<MapCameraPosition>, @ViewBuilder content: () -> Content) {
        self._cameraPosition = cameraPosition
        self.content = content()
    }

    public var body: some View {
        content
    }
}
