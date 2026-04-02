import SwiftUI

struct ModernTheme {
    static let accent = Color(red: 0.85, green: 0.55, blue: 0.35)
    static let success = Color.green
    static let danger = Color.red
    static let info = Color.blue

    static let background = Color(nsColor: .windowBackgroundColor)
    static let secondaryBackground = Color(nsColor: .controlBackgroundColor)
    static let tertiaryBackground = Color(nsColor: .controlBackgroundColor).opacity(0.8)
    static let panel = secondaryBackground
    static let panelRaised = secondaryBackground
    static let inset = tertiaryBackground

    static let label = Color.primary
    static let secondaryLabel = Color.secondary
    static let subtext = secondaryLabel

    static let shadow = Color.black.opacity(0.05)
}

struct PurePointOverlayUIState {
    var isEnabled: Bool
    var isFilterExpanded: Bool
    var selectedCategoryIDs: Set<String>

    init(isEnabled: Bool, isFilterExpanded: Bool, selectedCategoryIDs: Set<String>) {
        self.isEnabled = isEnabled
        self.isFilterExpanded = isFilterExpanded
        self.selectedCategoryIDs = selectedCategoryIDs
    }

    init(overlay: PurePointOverlay, isEnabled: Bool) {
        self.isEnabled = isEnabled
        self.isFilterExpanded = true
        self.selectedCategoryIDs = Set(overlay.categories.map(\.id))
    }
}

struct VisiblePurePoint: Identifiable {
    let overlay: PurePointOverlay
    let point: ShuangbeiPurePoint
    let category: ShuangbeiPurePointCategory?

    var id: String { "\(overlay.id)::\(point.id)" }
}

struct PurePointRenderState {
    let points: [VisiblePurePoint]
    let totalMatchingCount: Int
    let viewportMatchingCount: Int
    let isViewportFiltered: Bool
    let isDensityLimited: Bool

    nonisolated(unsafe) static let empty = PurePointRenderState(
        points: [],
        totalMatchingCount: 0,
        viewportMatchingCount: 0,
        isViewportFiltered: false,
        isDensityLimited: false
    )
}

struct DeviceConnectionIndicator: View {
    let state: DeviceConnectionState

    var body: some View {
        Group {
            if state.isBusy {
                flowingWater
            } else {
                Circle()
                    .fill(circleColor)
                    .frame(width: 10, height: 10)
            }
        }
    }

    private var circleColor: Color {
        switch state {
        case .connected:
            return Color(red: 0.3, green: 0.7, blue: 0.4)
        case .failed:
            return Color(red: 0.85, green: 0.35, blue: 0.3)
        case .disconnected:
            return Color.secondary.opacity(0.45)
        case .connecting:
            return Color(red: 0.34, green: 0.67, blue: 0.86)
        }
    }

    private var flowingWater: some View {
        Capsule()
            .fill(Color(red: 0.84, green: 0.92, blue: 0.97))
            .frame(width: 40, height: 12)
            .overlay {
                GeometryReader { proxy in
                    TimelineView(.animation) { context in
                        let progress = context.date.timeIntervalSinceReferenceDate
                            .truncatingRemainder(dividingBy: 1.15) / 1.15
                        let offset = -24.0 + ((proxy.size.width + 24.0) * progress)

                        HStack(spacing: 6) {
                            ForEach(0..<3, id: \.self) { _ in
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.34, green: 0.67, blue: 0.86).opacity(0.2),
                                                Color(red: 0.24, green: 0.62, blue: 0.86),
                                                Color(red: 0.34, green: 0.67, blue: 0.86).opacity(0.2)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: 14, height: 7)
                            }
                        }
                        .offset(x: offset)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                }
                .clipShape(Capsule())
                .padding(.horizontal, 2)
            }
    }
}
