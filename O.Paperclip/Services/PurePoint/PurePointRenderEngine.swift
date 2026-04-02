import MapKit
import SwiftUI

public struct PurePointRenderEngine {
    static func renderState(
        for entries: [VisiblePurePoint],
        region: MKCoordinateRegion,
        padding: Double,
        limit: Int,
        activationCount: Int,
        wideSpanThreshold: Double
    ) -> PurePointRenderState {
        let validEntries = entries.filter {
            let coordinate = $0.point.coordinate
            return CLLocationCoordinate2DIsValid(coordinate) && coordinate.latitude.isFinite && coordinate.longitude.isFinite
        }
        guard !validEntries.isEmpty else { return .empty }

        let regionNorm = region
        let viewportFilteringNeeded = shouldViewportFilter(count: validEntries.count, region: regionNorm, activationCount: activationCount, wideSpanThreshold: wideSpanThreshold)
        let viewportEntries = viewportFilteringNeeded
            ? validEntries.filter { contains($0.point.coordinate, in: regionNorm, paddingFactor: padding) }
            : validEntries

        let rendered = cappedEntries(viewportEntries, limit: limit, region: regionNorm)
        return PurePointRenderState(
            points: rendered,
            totalMatchingCount: validEntries.count,
            viewportMatchingCount: viewportEntries.count,
            isViewportFiltered: viewportFilteringNeeded,
            isDensityLimited: viewportEntries.count > rendered.count
        )
    }

    // MARK: - Helpers moved from ContentView.swift
    static func shouldViewportFilter(count: Int, region: MKCoordinateRegion, activationCount: Int, wideSpanThreshold: Double) -> Bool {
        count > activationCount || region.span.latitudeDelta > wideSpanThreshold || region.span.longitudeDelta > wideSpanThreshold
    }

    static func contains(_ coordinate: CLLocationCoordinate2D, in region: MKCoordinateRegion, paddingFactor: Double = 0) -> Bool {
        guard CLLocationCoordinate2DIsValid(coordinate), coordinate.latitude.isFinite, coordinate.longitude.isFinite else { return false }
        let latPadding = region.span.latitudeDelta * paddingFactor
        let lonPadding = region.span.longitudeDelta * paddingFactor
        let minLat = region.center.latitude - (region.span.latitudeDelta / 2) - latPadding
        let maxLat = region.center.latitude + (region.span.latitudeDelta / 2) + latPadding
        let minLon = region.center.longitude - (region.span.longitudeDelta / 2) - lonPadding
        let maxLon = region.center.longitude + (region.span.longitudeDelta * 0.5) + lonPadding
        return coordinate.latitude >= minLat && coordinate.latitude <= maxLat && coordinate.longitude >= minLon && coordinate.longitude <= maxLon
    }

    static func cappedEntries(_ entries: [VisiblePurePoint], limit: Int, region: MKCoordinateRegion) -> [VisiblePurePoint] {
        guard entries.count > limit else { return entries }
        let latSpan = max(region.span.latitudeDelta, AppConstants.Map.minimumSpanDelta)
        let lonSpan = max(region.span.longitudeDelta, AppConstants.Map.minimumSpanDelta)
        let aspectRatio = max(lonSpan / latSpan, 0.5)
        let columnCount = max(1, Int((Double(limit) * aspectRatio).squareRoot().rounded(.up)))
        let rowCount = max(1, Int(ceil(Double(limit) / Double(columnCount))))
        let minLat = region.center.latitude - (region.span.latitudeDelta / 2)
        let minLon = region.center.longitude - (region.span.longitudeDelta / 2)

        var bucketed: [String: VisiblePurePoint] = [:]
        for entry in entries {
            let coordinate = entry.point.coordinate
            let normalizedX = (coordinate.longitude - minLon) / lonSpan
            let normalizedY = (coordinate.latitude - minLat) / latSpan
            let x = min(columnCount - 1, max(0, Int(floor(normalizedX * Double(columnCount)))))
            let y = min(rowCount - 1, max(0, Int(floor(normalizedY * Double(rowCount)))))
            let key = "\(x):\(y)"
            if bucketed[key] == nil {
                bucketed[key] = entry
            }
        }

        var result = entries.filter { bucketed[bucketKey(for: $0.point.coordinate, region: region, columns: columnCount, rows: rowCount)]?.id == $0.id }
        if result.count > limit { result = Array(result.prefix(limit)) }
        if result.count == limit { return result }

        let existingIDs = Set(result.map { $0.id })
        let remaining = entries.filter { !existingIDs.contains($0.id) }
        result.append(contentsOf: remaining.prefix(limit - result.count))
        return result
    }

    static func bucketKey(for coordinate: CLLocationCoordinate2D, region: MKCoordinateRegion, columns: Int, rows: Int) -> String {
        let latSpan = max(region.span.latitudeDelta, AppConstants.Map.minimumSpanDelta)
        let lonSpan = max(region.span.longitudeDelta, AppConstants.Map.minimumSpanDelta)
        let minLat = region.center.latitude - (region.span.latitudeDelta / 2)
        let minLon = region.center.longitude - (region.span.longitudeDelta / 2)
        let normalizedX = (coordinate.longitude - minLon) / lonSpan
        let normalizedY = (coordinate.latitude - minLat) / latSpan
        let x = min(columns - 1, max(0, Int(floor(normalizedX * Double(columns)))))
        let y = min(rows - 1, max(0, Int(floor(normalizedY * Double(rows)))))
        return "\(x):\(y)"
    }

    static func safeMapColor(for category: ShuangbeiPurePointCategory?) -> Color {
        (category?.color ?? .blue).opacity(0.98)
    }
}
