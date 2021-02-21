import SwiftUI
import Sleuth

extension History {
    struct Cell: View {
        let page: Share.Page
        
        var body: some View {
            Link(destination: page.url) {
                HStack {
                    VStack(alignment: .leading) {
                        if !page.title.isEmpty {
                            Text(verbatim: page.title)
                                .font(.footnote)
                                .lineLimit(3)
                        }
                        Text(verbatim: page.subtitle)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .lineLimit(page.title.isEmpty ? 4 : 2)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
            }
        }
    }
}
