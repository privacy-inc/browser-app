import AppKit

extension Search.Field {
    final class Cell: NSTextFieldCell {
        private let editor = Editor()
        
        required init(coder: NSCoder) { super.init(coder: coder) }
        override init(textCell: String) {
            super.init(textCell: textCell)
            truncatesLastVisibleLine = true
        }
        
        override func draw(withFrame: NSRect, in view: NSView) {
            super.drawInterior(withFrame: withFrame, in: view)
        }
        
        override func drawInterior(withFrame: NSRect, in: NSView) { }

        override func drawingRect(forBounds: NSRect) -> NSRect {
            var rect = forBounds
            rect.origin.x += 2
            rect.size.width -= 4
            return super.drawingRect(forBounds: rect)
        }
        
        override func fieldEditor(for: NSView) -> NSTextView? {
            editor
        }
    }
}
