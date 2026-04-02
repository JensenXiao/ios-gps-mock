import SwiftUI

struct DeviceStatusSectionView: View {
    @Bindable var vm: AppViewModel
    let isCompactSidebar: Bool
    @Binding var isConnectionAdvancedExpanded: Bool
    @Binding var tunnelUDID: String
    @Binding var manualRsdHost: String
    @Binding var manualRsdPort: String
    @Binding var isWirelessMode: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("裝置狀態").font(.subheadline).fontWeight(.semibold).foregroundColor(ModernTheme.label)

            HStack {
                DeviceConnectionIndicator(state: vm.deviceManager.connectionState)
                Text(vm.deviceManager.deviceName)
                    .font(.subheadline)
                    .foregroundColor((vm.deviceManager.isConnected || vm.deviceManager.isConnecting) ? .primary : .secondary)
                Spacer()
                Button(action: {
                    vm.deviceManager.isConnected ? vm.deviceManager.disconnect() : vm.deviceManager.connectDevice()
                }) {
                    Text(vm.deviceManager.isConnecting ? "連線中…" : (vm.deviceManager.isConnected ? "中斷連線" : "開始連線"))
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .disabled(vm.deviceManager.isConnecting)
            }
            .padding(10)
            .background(ModernTheme.panelRaised)
            .cornerRadius(10)
            .shadow(color: ModernTheme.shadow, radius: 8, y: 3)

            Toggle(isOn: $isWirelessMode) {
                HStack(spacing: 4) {
                    Image(systemName: isWirelessMode ? "wifi" : "cable.connector")
                        .font(.caption)
                    Text(isWirelessMode ? "Wi‑Fi 無線連線" : "USB 有線連線")
                        .font(.caption)
                }
            }
            .tint(ModernTheme.accent)
            .disabled(vm.deviceManager.isConnecting || vm.deviceManager.isConnected)

            if let err = vm.deviceManager.lastError, !err.isEmpty {
                Text(err)
                    .font(.caption)
                    .foregroundColor(.red)
                    .lineLimit(3)
            } else if !vm.deviceManager.isConnected {
                Text(isWirelessMode
                     ? "確保 iPhone 與 Mac 在同一個 Wi‑Fi 網路，按下開始連線。"
                     : "先插上手機並解鎖，按下開始連線即可。")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            DisclosureGroup(isExpanded: $isConnectionAdvancedExpanded) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("指定裝置 UDID（選填）")
                        .font(.caption)
                        .foregroundColor(ModernTheme.secondaryLabel)
                    TextField("UDID（留空自動偵測）", text: $tunnelUDID)
                        .textFieldStyle(.roundedBorder)
                        .font(.caption)

                    Divider()

                    Text("手動 RSD 端點（選填）")
                        .font(.caption)
                        .foregroundColor(ModernTheme.secondaryLabel)
                    HStack(spacing: 6) {
                        TextField("RSD Host", text: $manualRsdHost)
                            .textFieldStyle(.roundedBorder)
                            .font(.caption)
                        TextField("Port", text: $manualRsdPort)
                            .textFieldStyle(.roundedBorder)
                            .font(.caption)
                            .frame(width: 60)
                    }

                    Text("只有自動連線失敗時才需要手動設定。可用 pymobiledevice3 remote start-tunnel 取得 RSD。")
                        .font(.system(size: 9))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 4)
            } label: {
                Text("進階連線設定")
                    .font(.caption)
                    .foregroundColor(ModernTheme.secondaryLabel)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("目前進度：\(vm.deviceManager.connectionStage)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                if !vm.deviceManager.debugLog.isEmpty && vm.appState != .moving {
                    debugLogPanel
                }
            }

        }
    }

    private var debugLogPanel: some View {
        let recentLines = Array(vm.deviceManager.debugLog.suffix(isCompactSidebar ? 5 : 8))

        return ScrollView {
            LazyVStack(alignment: .leading, spacing: 2) {
                ForEach(Array(recentLines.enumerated()), id: \.offset) { _, line in
                    Text(line)
                        .font(.system(size: 10, weight: .regular, design: .monospaced))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .frame(maxHeight: isCompactSidebar ? 64 : 90)
        .padding(6)
        .background(ModernTheme.inset)
        .cornerRadius(6)
    }

}
