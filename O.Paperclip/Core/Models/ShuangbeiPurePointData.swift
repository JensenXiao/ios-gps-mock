import SwiftUI
import MapKit

public struct ShuangbeiPurePointCategory: Identifiable, Hashable {
    public let id: String
    public let displayName: String
    public let colorHex: String
    public let groupName: String

    public var color: Color { Color(hex: colorHex) }
}

public struct ShuangbeiPurePoint: Identifiable, Hashable {
    public let id: String
    public let name: String
    public let latitude: Double
    public let longitude: Double
    public let categoryID: String
    public let groupName: String
    public let note: String?

    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

private extension Color {
    init(hex: String) {
        let sanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        let normalized: String
        switch sanitized.count {
        case 6:
            normalized = sanitized
        case 8:
            normalized = String(sanitized.suffix(6))
        default:
            self = .blue
            return
        }
        var int: UInt64 = 0
        Scanner(string: normalized).scanHexInt64(&int)
        let red = Double((int >> 16) & 0xFF) / 255.0
        let green = Double((int >> 8) & 0xFF) / 255.0
        let blue = Double(int & 0xFF) / 255.0
        self = Color(red: red, green: green, blue: blue)
    }
}
