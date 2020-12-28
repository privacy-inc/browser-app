import AppKit
import Combine

final class Trackers: NSWindow {
    private var sub: AnyCancellable?
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 420, height: 240),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: false)
        toolbar = .init()
        titlebarAppearsTransparent = true
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        center()
        
        let scroll = Scroll()
        scroll.hasVerticalScroller = true
        scroll.hasHorizontalScroller = false
        scroll.verticalScroller!.controlSize = .mini
        contentView!.addSubview(scroll)
        
        scroll.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.rightAnchor).isActive = true
        scroll.right.constraint(equalTo: contentView!.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        sub = (NSApp as! App).blocked.receive(on: DispatchQueue.main).sink { [weak self] in
            scroll.views.forEach { $0.removeFromSuperview() }
            self?.title = NSLocalizedString("\($0.count) trackers blocked", comment: "")
            guard !$0.isEmpty else { return }
            var top = scroll.top
            
            $0.sorted().forEach {
                let text = Text()
                text.stringValue = $0
                text.maximumNumberOfLines = 1
                text.font = .systemFont(ofSize: 14, weight: .regular)
                text.textColor = .secondaryLabelColor
                scroll.add(text)
                
                if top != scroll.top {
                    let separator = NSView()
                    separator.translatesAutoresizingMaskIntoConstraints = false
                    separator.wantsLayer = true
                    separator.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
                    
                    scroll.add(separator)
                    
                    separator.topAnchor.constraint(equalTo: top, constant: 7).isActive = true
                    separator.leftAnchor.constraint(equalTo: scroll.left, constant: 30).isActive = true
                    separator.rightAnchor.constraint(lessThanOrEqualTo: scroll.right, constant: -30).isActive = true
                    separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
                    top = separator.bottomAnchor
                }
                
                text.topAnchor.constraint(equalTo: top, constant: 7).isActive = true
                text.leftAnchor.constraint(equalTo: scroll.left, constant: 30).isActive = true
                text.rightAnchor.constraint(lessThanOrEqualTo: scroll.right, constant: -30).isActive = true
                top = text.bottomAnchor
            }
            
            scroll.bottom.constraint(equalTo: top, constant: 30).isActive = true
        }
    }
}