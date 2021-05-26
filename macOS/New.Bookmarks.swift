import AppKit
import Combine
import Archivable

extension New {
    final class Bookmarks: NSView {
        private var subscription: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init(id: UUID) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let layer = CALayer()
            self.layer = layer
            wantsLayer = true
            layer.backgroundColor = NSColor.unemphasizedSelectedTextBackgroundColor.cgColor
            layer.cornerRadius = 12
            
            subscription = Cloud
                .shared
                .archive
                .map(\.bookmarks)
                .removeDuplicates()
                .sink {
                    layer
                        .sublayers?
                        .forEach {
                            $0.removeFromSuperlayer()
                        }

                    $0
                        .map { page -> NSAttributedString in
                            {
                                if !page.title.isEmpty {
                                    $0.append(.init(string: page.title, attributes: [:]))
                                }
                                if !page.access.domain.isEmpty {
                                    if !page.title.isEmpty {
                                        $0.append(.init(string: "\n"))
                                    }
                                    $0.append(.init(string: page.access.domain, attributes: [:]))
                                }
                                return $0
                            } (NSMutableAttributedString())
                        }
                        .forEach {
                            print($0)
                        let cell = Cell()
                        cell.string = $0
                        layer.addSublayer(cell)
                    }
                }
        }
    }
}
