import Foundation
import MapKit

enum RouteMotionEngine {
    enum LoopMode {
        case singlePass
        case pingPong
        case circular
    }

    static func targetDistance(traveledDistance: Double, routeDistance: Double, loopMode: LoopMode) -> Double? {
        guard routeDistance > 0 else { return nil }

        switch loopMode {
        case .circular:
            return traveledDistance.truncatingRemainder(dividingBy: routeDistance)
        case .pingPong:
            let cycleDistance = routeDistance * 2.0
            let phase = traveledDistance.truncatingRemainder(dividingBy: cycleDistance)
            return phase <= routeDistance ? phase : (cycleDistance - phase)
        case .singlePass:
            guard traveledDistance <= routeDistance else { return nil }
            return traveledDistance
        }
    }

    static func coordinate(
        at targetDistance: Double,
        in points: [CLLocationCoordinate2D],
        distances: [Double]
    ) -> CLLocationCoordinate2D? {
        guard points.count >= 2, distances.count == points.count else { return points.first }
        guard let total = distances.last else { return points.first }

        if targetDistance <= 0 { return points.first }
        if targetDistance >= total { return points.last }

        var low = 0
        var high = distances.count - 1
        while low < high {
            let mid = (low + high) / 2
            if distances[mid] < targetDistance {
                low = mid + 1
            } else {
                high = mid
            }
        }

        let upper = max(1, low)
        let lower = upper - 1
        let segmentDistance = distances[upper] - distances[lower]
        if segmentDistance <= 0 { return points[upper] }

        let ratio = max(0, min(1, (targetDistance - distances[lower]) / segmentDistance))
        let lat = points[lower].latitude + (points[upper].latitude - points[lower].latitude) * ratio
        let lon = points[lower].longitude + (points[upper].longitude - points[lower].longitude) * ratio
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        return CLLocationCoordinate2DIsValid(coordinate) ? coordinate : nil
    }

    static func cumulativeDistances(for points: [CLLocationCoordinate2D]) -> [Double] {
        guard !points.isEmpty else { return [] }
        if points.count == 1 { return [0] }

        var result: [Double] = [0]
        var total: Double = 0
        for i in 0..<(points.count - 1) {
            let p1 = CLLocation(latitude: points[i].latitude, longitude: points[i].longitude)
            let p2 = CLLocation(latitude: points[i + 1].latitude, longitude: points[i + 1].longitude)
            total += p1.distance(from: p2)
            result.append(total)
        }
        return result
    }
}
