import AppKit

extension Settings.Title {
    final class Option: Control {
        private weak var image: Image!
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(title: String, image: String) {
            let image = Image(icon: image)
            image.symbolConfiguration = .init(textStyle: .body)
            self.image = image
            
            let text = Text()
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .callout)
            self.text = text
            
            super.init(layer: true)
            layer!.cornerRadius = 4
            
            addSubview(image)
            addSubview(text)
            
            heightAnchor.constraint(equalToConstant: 32).isActive = true
            rightAnchor.constraint(equalTo: image.rightAnchor, constant: 10).isActive = true
            
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.leftAnchor.constraint(equalTo: text.rightAnchor, constant: 10).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                image.contentTintColor = .white
                text.textColor = .white
                layer!.backgroundColor = NSColor.controlAccentColor.cgColor
            case .highlighted:
                layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.2).cgColor
            default:
                layer!.backgroundColor = .clear
                image.contentTintColor = .labelColor
                text.textColor = .labelColor
            }
        }
    }
}
