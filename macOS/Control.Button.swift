import AppKit

extension Control {
    final class Button: Control {
        override var enabled: Bool {
            didSet {
                if enabled {
                    hoverOff()
                } else {
                    hoverOn()
                }
            }
        }
        
        required init?(coder: NSCoder) { nil }
        init(_ icon: String) {
            super.init()
            let icon = NSImageView(image: NSImage(systemSymbolName: icon, accessibilityDescription: nil)!)
            icon.symbolConfiguration = .init(pointSize: 16, weight: .bold)
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.imageScaling = .scaleNone
            icon.contentTintColor = .systemBlue
            addSubview(icon)
            
            widthAnchor.constraint(equalToConstant: 40).isActive = true
            heightAnchor.constraint(equalTo: widthAnchor).isActive = true
            
            icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
        
        override func hoverOn() {
            alphaValue = 0.3
        }
        
        override func hoverOff() {
            alphaValue = 1
        }
    }
}
