import SwiftUI

// Simple search bar component used by ContentView. This keeps the search input
// self-contained and lets ContentView supply the action to perform the search.
public struct SearchBar: View {
    @Binding public var placeKeyword: String
    public let onSearch: () -> Void

    public init(placeKeyword: Binding<String>, onSearch: @escaping () -> Void) {
        self._placeKeyword = placeKeyword
        self.onSearch = onSearch
    }

    public var body: some View {
        HStack(spacing: 6) {
            TextField("搜尋地點（例如 Taipei 101）", text: $placeKeyword)
                .textFieldStyle(.roundedBorder)
            Button("搜尋") { onSearch() }
                .buttonStyle(.bordered)
                .controlSize(.small)
        }
    }
}
