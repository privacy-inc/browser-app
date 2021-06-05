import AppKit

final class Image: NSImageView {
    required init?(coder: NSCoder) { nil }
    init(icon: String) {
        super.init(frame: .zero)
        image = .init(systemSymbolName: icon, accessibilityDescription: nil)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func hitTest(_: NSPoint) -> NSView? {
        nil
    }
}
