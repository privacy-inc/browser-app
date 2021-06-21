import SwiftUI

extension Fast.Content {
    struct Cell: View {
        let item: Fast.Entry.Item
        
        var body: some View {
            Link(destination: URL(string: "privacy://\(item.sites == .bookmarks ? "bookmark" : "history")/\(item.id)")!) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.systemBackground))
                    VStack(alignment: .leading) {
                        if !item.title.isEmpty {
                            Text(verbatim: item.title)
                                .foregroundColor(.primary)
                        }
                        Text(verbatim: item.domain)
                            .foregroundColor(.secondary)
                    }
                    .font(.caption2)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(10)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
            }
        }
    }
}
