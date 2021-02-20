import SwiftUI
import WidgetKit
import Sleuth

extension History {
    struct Content: View {
        let pages: [Share.Page]
        @Environment(\.widgetFamily) private var family: WidgetFamily
        
        var body: some View {
            ZStack {
                Color(white: 0.125)
                    .widgetURL(URL(string: Scheme.privacy_search.url)!)
                if pages.isEmpty {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Placeholder()
                                .padding()
                            Spacer()
                        }
                        Spacer()
                    }
                } else {
                    GeometryReader { geo in
                        switch family {
                        case .systemLarge:
                            HStack(alignment: .top, spacing: 0) {
                                VStack(spacing: 0) {
                                    Cell(page: pages.first!)
                                    if pages.count > 2 {
                                        Cell(page: pages[2])
                                            .padding(.top)
                                        if pages.count > 4 {
                                            Cell(page: pages[4])
                                                .padding(.top)
                                        }
                                    }
                                }
                                .frame(width: (geo.size.width * 0.5) - 10)
                                if pages.count > 1 {
                                    VStack(spacing: 0) {
                                        Cell(page: pages[1])
                                        if pages.count > 3 {
                                            Cell(page: pages[3])
                                                .padding(.top)
                                            if pages.count > 5 {
                                                Cell(page: pages[5])
                                                    .padding(.top)
                                            }
                                        }
                                    }
                                    .frame(width: (geo.size.width * 0.5) - 10)
                                    .padding(.leading, 20)
                                } else {
                                    Spacer()
                                }
                            }
                        case .systemMedium:
                            HStack(alignment: .top, spacing: 0) {
                                Cell(page: pages.first!)
                                    .frame(width: (geo.size.width * 0.5) - 10)
                                if pages.count > 1 {
                                    Cell(page: pages[1])
                                        .frame(width: (geo.size.width * 0.5) - 10)
                                        .padding(.leading, 20)
                                } else {
                                    Spacer()
                                }
                            }
                        default:
                            Cell(page: pages.first!)
                        }
                    }
                    .padding([.leading, .trailing, .top], 20)
                }
            }
        }
    }
}
