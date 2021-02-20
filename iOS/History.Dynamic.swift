import SwiftUI
import Sleuth

extension History {
    struct Dynamic: View {
        @Binding var session: Session
        let size: Size
        let horizontal: Bool
        @State private var list = [[Page]]()
        
        var body: some View {
            ScrollView {
                HStack(alignment: .top) {
                    Spacer()
                    ForEach(list, id: \.self) { pages in
                        VStack {
                            ForEach(pages) { page in
                                Cell(page: page, delete: delete) {
                                    UIApplication.shared.resign()
                                    var page = page
                                    page.date = .init()
                                    session.page = page
                                }
                            }
                            if !horizontal {
                                Spacer()
                                    .frame(height: Metrics.search.bar)
                            }
                        }.frame(width: size.width)
                        Spacer()
                    }
                }
            }
            .animation(.spring(blendDuration: 0.4))
            .onAppear {
                if session.pages.isEmpty {
                    session.history.send()
                } else {
                    refresh()
                }
            }
            .onChange(of: session.pages) { _ in
                refresh()
            }
            .onChange(of: session.search) { _ in
                refresh()
            }
        }
        
        private func refresh() {
            list = ({ search in
                search.isEmpty
                    ? session.pages
                    : session.pages.filter {
                        $0.title.localizedCaseInsensitiveContains(search)
                        || $0.url.absoluteString.localizedCaseInsensitiveContains(search)
                    }
            } (session.search.trimmingCharacters(in: .whitespacesAndNewlines))).reduce(into: (.init(repeating: [], count: size.lines), size.lines)) {
                $0.1 = $0.1 < size.lines - 1 ? $0.1 + 1 : 0
                $0.0[$0.1].append($1)
            }.0
        }
        
        private func delete(_ page: Page) {
            FileManager.delete(page)
            session.pages.firstIndex(of: page).map {
                _ = session.pages.remove(at: $0)
            }
        }
    }
}