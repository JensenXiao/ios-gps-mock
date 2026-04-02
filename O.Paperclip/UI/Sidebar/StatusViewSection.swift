import SwiftUI
import MapKit

struct StatusViewSection: View {
    @Bindable var vm: AppViewModel
    let routeColors: [Color]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            switch vm.appState {
            case .selectingA:
                if vm.operationMode == .multiPoint {
                    Text("Shift + 點擊新增路線點（至少 2 點）").foregroundColor(ModernTheme.accent)
                } else if vm.operationMode == .fixedPoint {
                    Text("Shift + 點擊設定定位點").foregroundColor(ModernTheme.accent)
                } else {
                    Text("Shift + 點擊設定「起點 A」").foregroundColor(ModernTheme.accent)
                }
            case .confirmingA:
                if vm.operationMode == .fixedPoint {
                    Text("已選擇定位點，請在地圖標記上直接確認/取消").foregroundColor(ModernTheme.success)
                } else {
                    Text("已選擇起點 A，請在地圖標記上直接確認/取消").foregroundColor(ModernTheme.success)
                }
            case .selectingB:
                Text("Shift + 點擊設定「終點 B」").foregroundColor(ModernTheme.accent)
            case .confirmingB:
                Text("已選擇終點 B，請在地圖標記上直接確認/取消").foregroundColor(ModernTheme.success)
            case .calculatingRoute:
                Text("計算路線中...").foregroundColor(ModernTheme.info)
            case .routeSelection:
                Text("選擇一條路線").foregroundColor(Color(red: 0.5, green: 0.35, blue: 0.7))
                Picker("選擇路線", selection: $vm.selectedRouteIndex) {
                    ForEach(Array(vm.routes.enumerated()), id: \.offset) { index, route in
                        Text("路線 \(index + 1) (\(String(format: "%.1f", route.distance / 1000)) km)").tag(index)
                    }
                }
                .pickerStyle(.radioGroup)
            case .readyToMove, .moving:
                Text(vm.appState == .readyToMove ? "準備就緒" : "移動中...").foregroundColor(ModernTheme.info)
            }
        }
        .font(.headline)
        .animation(.easeInOut, value: vm.appState)
    }
}
