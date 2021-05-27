import AppKit
import Combine
import Archivable

extension New {
    final class History: Collection<New.History.Cell> {
        private static let width = CGFloat(120)
        private static let padding = CGFloat(4)
        private static let insets = CGFloat(6)
        
        required init?(coder: NSCoder) { nil }
        init(id: UUID) {
            super.init()
            translatesAutoresizingMaskIntoConstraints = false
            
            let columns = PassthroughSubject<(count: Int, width: CGFloat), Never>()
            let info = PassthroughSubject<[CollectionItemInfo], Never>()
            
            NotificationCenter
                .default
                .publisher(for: NSView.frameDidChangeNotification, object: contentView)
                .compactMap {
                    ($0.object as? NSClipView)?.bounds.width
                }
                .removeDuplicates()
                .map {
                    let total = $0 - (Self.horizontal * 2) - Self.padding
                    let horizontal = Self.width + Self.padding
                    let count = Int(floor(total / horizontal))
                    return (count: count, width: Self.width + (total.truncatingRemainder(dividingBy: horizontal) / .init(count)))
                }
                .subscribe(columns)
                .store(in: &subs)
            
            Cloud
                .shared
                .archive
                .map(\.browse)
                .removeDuplicates()
                .map {
                    $0.prefix(5).map { browse in
                        .init(
                            id: browse.id,
                            string: .make {
                                $0.add(RelativeDateTimeFormatter().string(from: browse.date),
                                       font: .preferredFont(forTextStyle: .callout),
                                       color: .secondaryLabelColor)
                                if !browse.page.title.isEmpty {
                                    $0.linebreak()
                                    $0.add(browse.page.title,
                                           font: .preferredFont(forTextStyle: .body),
                                           color: .labelColor)
                                }
                                if !browse.page.access.domain.isEmpty {
                                    if !browse.page.title.isEmpty {
                                        $0.linebreak()
                                    }
                                    $0.add(browse.page.access.domain,
                                           font: .preferredFont(forTextStyle: .callout),
                                           color: .secondaryLabelColor)
                                }
                            })
                    }
                }
                .subscribe(info)
                .store(in: &subs)
            
            info
                .removeDuplicates()
                .combineLatest(columns
                                .removeDuplicates {
                                    $0.count == $1.count
                                        || $0.width == $1.width
                                })
                .sink { [weak self] (info: [CollectionItemInfo], columns: (count: Int, width: CGFloat)) in
                    let result = info
                        .reduce(into: (
                                    items: Set<CollectionItem>(),
                                    column: columns.count,
                                    x: CGFloat(),
                                    y: (0 ..< columns.count)
                                        .reduce(into: [Int: CGFloat]()) {
                                            $0[$1] = Self.insets
                                        })) {
                            if $0.column < columns.count - 1 {
                                $0.column += 1
                            } else {
                                $0.column = 0
                                $0.x = Self.insets
                            }
                            let height = ceil($1.string.height(for: columns.width - Cell.insets2) + Cell.insets2)
                            $0.items.insert(.init(
                                                info: $1,
                                                rect: .init(
                                                    x: $0.x,
                                                    y: $0.y[$0.column]!,
                                                    width: columns.width,
                                                    height: height)))
                            $0.x += columns.width + Self.padding
                            $0.y[$0.column]! += height + Self.padding
                        }
                    self?.items.send(result.items)
                    self?.height.send(result
                                        .y
                                        .map(\.1)
                                        .max()
                                        .map {
                                            $0 + Self.insets
                                        } ?? 0)
                }
                .store(in: &subs)
        }
    }
}