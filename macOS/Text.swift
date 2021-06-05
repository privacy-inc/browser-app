import AppKit

final class Text: NSTextField {
    override var acceptsFirstResponder: Bool { false }
    override var canBecomeKeyView: Bool { false }
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        isBezeled = false
        isEditable = false
        setAccessibilityRole(.staticText)
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        isSelectable ? super.hitTest(point) : nil
    }
}
