import SwiftUI

// Lightweight wrapper to host sidebar content. The actual UI is constructed
// by the caller, allowing a clean separation of layout concerns without
// affecting existing behavior.
public struct SidebarView<Content: View>: View {
    public let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
    }
}
