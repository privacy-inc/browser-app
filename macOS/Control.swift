import AppKit
import Combine

class Control: NSView {
    var state = Control.State.on {
        didSet {
            update()
        }
    }
    
    let click = PassthroughSubject<Void, Never>()
    
    override var mouseDownCanMoveWindow: Bool { false }
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setAccessibilityElement(true)
        setAccessibilityRole(.button)
        addTrackingArea(.init(rect: bounds, options: [.mouseEnteredAndExited, .activeInActiveApp, .inVisibleRect], owner: self))
    }
    
    override func resetCursorRects() {
        addCursorRect(bounds, cursor: .arrow)
    }
    
    override func mouseEntered(with: NSEvent) {
        guard state == .on else { return }
        state = .highlighted
    }
    
    override func mouseExited(with: NSEvent) {
        guard state == .highlighted else { return }
        state = .on
    }
    
    override func mouseDown(with: NSEvent) {
        guard state == .on || state == .highlighted else {
            super.mouseDown(with: with)
            return
        }
        window?.makeFirstResponder(self)
        state = .pressed
    }
    
    override func mouseUp(with: NSEvent) {
        guard state == .highlighted || state == .on || state == .pressed else { return }
        if bounds.contains(convert(with.locationInWindow, from: nil)) {
            state = .on
            click.send()
        } else {
            state = .on
            super.mouseUp(with: with)
        }
    }
    
    func update() {
        isHidden = state == .hidden
        alphaValue = state == .off ? 0.25 : 1
    }
}
