import SwiftUI

struct UnexpectedTerminationSectionView: View {
    let diagnostics: AppDiagnostics
    let unexpectedTermination: UnexpectedTerminationRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("上次啟動疑似非正常結束")
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(unexpectedTermination.reason)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(diagnostics.logsDirectoryURL.path)
                .font(.caption2)
                .foregroundColor(.secondary)
                .textSelection(.enabled)
            Button("開啟診斷資料夾") {
                diagnostics.openLogsDirectory()
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
        .padding(10)
        .background(ModernTheme.panel)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(ModernTheme.accent)
                .frame(width: 3)
                .frame(maxHeight: .infinity)
        }
    }
}
