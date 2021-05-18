import SwiftUI

struct Collection: View {
    @Binding var session: Session
    let modal: Session.Modal
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        NavigationView {
            List {
                switch modal {
                case .bookmarks:
                    Bookmarks(session: $session, bookmarks: session.archive.bookmarks, dismiss: dismiss)
                case .history:
                    History(session: $session, browse: session.archive.browse, dismiss: dismiss)
                default:
                    EmptyView()
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(title, displayMode: .large)
            .navigationBarItems(trailing:
                                    Button(action: dismiss) {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.secondary)
                                            .frame(width: 30, height: 50)
                                            .padding(.leading, 40)
                                            .contentShape(Rectangle())
                                    })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var title: String {
        switch modal {
        case .bookmarks:
            return "Bookmarks"
        case .history:
            return "Recent"
        }
    }
    
    private func dismiss() {
        visible.wrappedValue.dismiss()
    }
}
