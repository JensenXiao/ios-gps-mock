import SwiftUI

// Route control panel wrapper moved from ContentView. Keeps business logic intact
// while presenting a clean, focused UI surface.
struct RouteControlPanel: View {
    @Bindable var vm: AppViewModel

    init(vm: AppViewModel) {
        self.vm = vm
    }

    var body: some View {
        Button(action: vm.handleMainAction) {
            Text(vm.buttonTitle).fontWeight(.medium).frame(maxWidth: .infinity).padding(.vertical, 8)
        }
        .buttonStyle(.borderedProminent)
        .tint(vm.appState == .moving ? Color.red : Color(red: 0.85, green: 0.55, blue: 0.35))
        .controlSize(.regular)
        .disabled(
            ( (vm.appState == .selectingA && !(vm.operationMode == .multiPoint && vm.waypoints.count >= 2)) || vm.appState == .selectingB ) ||
            vm.appState == .calculatingRoute ||
            ((vm.appState == .readyToMove || vm.appState == .moving) && !vm.deviceManager.isConnected)
        )
    }
}
