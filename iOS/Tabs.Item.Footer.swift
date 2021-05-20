import SwiftUI

extension Tabs.Item {
    struct Footer: View {
        @Binding var session: Session
        let id: UUID
        
        var body: some View {
            VStack(alignment: .leading) {
                if !title.isEmpty {
                    Text(verbatim: title)
                        .font(.footnote)
                        .lineLimit(1)
                        .padding(.horizontal)
                }
                Text(verbatim: subtitle)
                    .font(.caption2)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                Spacer()
            }
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
        }
        
        private var title: String {
            switch session.tab.state(id) {
            case .new:
                return ""
            case let .browse(browse):
                return session.archive.page(browse).title
            case let .error(_, error):
                return error.description
            }
        }
        
        private var subtitle: String {
            switch session.tab.state(id) {
            case .new:
                return " "
            case let .browse(browse):
                return session.archive.page(browse).access.domain
            case let .error(_, error):
                return error.domain
            }
        }
    }
}
