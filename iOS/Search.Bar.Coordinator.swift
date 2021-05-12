import UIKit

extension Search.Bar {
    final class Coordinator: UIView, UIKeyInput, UITextFieldDelegate {
        private weak var field: UITextField!
        private var editable = true
        private let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 48), inputViewStyle: .keyboard)
        private let wrapper: Search.Bar
        override var inputAccessoryView: UIView? { input }
        override var canBecomeFirstResponder: Bool { editable }
        
        var hasText: Bool {
            get {
                field.text?.isEmpty == false
            }
            set { }
        }
        
        required init?(coder: NSCoder) { nil }
        init(wrapper: Search.Bar) {
            self.wrapper = wrapper
            super.init(frame: .zero)
            
            let field = UITextField()
            field.translatesAutoresizingMaskIntoConstraints = false
            field.clearButtonMode = .always
            field.autocorrectionType = .no
            field.autocapitalizationType = .sentences
            field.spellCheckingType = .yes
            field.backgroundColor = UIApplication.dark ? .init(white: 1, alpha: 0.2) : .init(white: 1, alpha: 0.6)
            field.tintColor = .label
            field.keyboardType = .webSearch
            field.allowsEditingTextAttributes = false
            field.delegate = self
            field.borderStyle = .roundedRect
            input.addSubview(field)
            self.field = field
            
            let cancel = UIButton()
            cancel.translatesAutoresizingMaskIntoConstraints = false
            cancel.setImage(UIImage(systemName: "xmark")?
                                .withConfiguration(UIImage.SymbolConfiguration(textStyle: .callout)), for: .normal)
            cancel.imageEdgeInsets.top = 4
            cancel.imageView!.tintColor = .secondaryLabel
            cancel.addTarget(self, action: #selector(self.dismiss), for: .touchUpInside)
            input.addSubview(cancel)
            
            field.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
            field.rightAnchor.constraint(equalTo: cancel.leftAnchor).isActive = true
            field.bottomAnchor.constraint(equalTo: input.bottomAnchor, constant: -4).isActive = true
            
            cancel.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor).isActive = true
            cancel.widthAnchor.constraint(equalToConstant: 50).isActive = true
            cancel.topAnchor.constraint(equalTo: input.topAnchor).isActive = true
            cancel.bottomAnchor.constraint(equalTo: input.bottomAnchor).isActive = true
            
            becomeFirstResponder()
        }
        
        @discardableResult override func becomeFirstResponder() -> Bool {
            DispatchQueue.main.async { [weak self] in
                self?.field.becomeFirstResponder()
            }
            return super.becomeFirstResponder()
        }
        
        func textFieldShouldEndEditing(_: UITextField) -> Bool {
            editable = false
            return true
        }
        
        func textFieldDidEndEditing(_: UITextField) {
            editable = true
        }
        
        func textFieldShouldReturn(_: UITextField) -> Bool {
            field.resignFirstResponder()
            field.text.map {
                print($0)
//                switch view.session.section {
//                case let .browse(id):
//                    Cloud.shared.browse(id, $0) { [weak self] in
//                        switch $0 {
//                        case .navigate:
//                            self?.bar.text = nil
//                            self?.changed()
//                        default: break
//                        }
//                        self?.view.session.load.send()
//                    }
//                case .history:
//                    Cloud.shared.browse($0) { [weak self] in
//                        switch $0 {
//                        case .navigate:
//                            self?.bar.text = nil
//                            self?.changed()
//                        default: break
//                        }
//                        self?.view.session.section = .browse($1)
//                    }
//                }
            }
            return true
        }
        
        func insertText(_: String) { }
        func deleteBackward() { }
        
        @objc private func dismiss() {
            field.text = nil
            field.resignFirstResponder()
            wrapper.session.section = wrapper.session.section.tab
        }
    }
}
