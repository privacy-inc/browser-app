import SwiftUI
import Sleuth

struct Search: View {
    @Binding var session: Session
    let id: UUID
    @State private var filter = ""
    @State private var bookmarks = [Filtered]()
    @State private var recent = [Filtered]()
    
    var body: some View {
        ZStack {
            Color(white: 0.2, opacity: 1)
                .edgesIgnoringSafeArea(.all)
            if bookmarks.isEmpty && recent.isEmpty {
                Image("blank")
                    .padding(.top, 100)
                    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
            } else {
                ScrollView(showsIndicators: false) {
                    Spacer()
                        .frame(height: 20)
                    if !bookmarks.isEmpty {
                        Autocomplete(session: $session, id: id, title: "BOOKMARKS", items: bookmarks)
                    }
                    if !recent.isEmpty {
                        Autocomplete(session: $session, id: id, title: "RECENT", items: recent)
                    }
                    Spacer()
                        .frame(height: 20)
                }
                .animation(.spring(blendDuration: 0.2))
            }
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 1)
                    .edgesIgnoringSafeArea(.horizontal)
            }
            Bar(session: $session, filter: $filter, id: id)
                .frame(height: 0)
        }
        .onAppear(perform: update)
        .onChange(of: filter) { _ in
            update()
        }
    }
    
    private func update() {
        bookmarks = session
            .archive
            .bookmarks
            .filter(filter)
        recent = session
            .archive
            .browse
            .filter(filter)
    }
}
