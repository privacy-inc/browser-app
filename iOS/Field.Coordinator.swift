import UIKit
import Combine
import Sleuth

extension Field {
    final class Coordinator: UIView, UIKeyInput, UISearchBarDelegate {
        private weak var bar: UISearchBar!
        private weak var rightView: NSLayoutConstraint!
        private var leftView: UIView!
        private var editable = true
        private var subs = Set<AnyCancellable>()
        private let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 62), inputViewStyle: .keyboard)
        private let view: Field
        override var inputAccessoryView: UIView? { input }
        override var canBecomeFirstResponder: Bool { editable }
        
        var hasText: Bool {
            get {
                bar.text?.isEmpty == false
            }
            set { }
        }
        
        required init?(coder: NSCoder) { nil }
        init(view: Field) {
            self.view = view
            super.init(frame: .zero)

            let bar = UISearchBar()
            bar.translatesAutoresizingMaskIntoConstraints = false
            bar.searchBarStyle = .minimal
            bar.autocapitalizationType = .none
            bar.autocorrectionType = .no
            bar.spellCheckingType = .yes
            bar.showsCancelButton = true
            bar.enablesReturnKeyAutomatically = false
            bar.barTintColor = .init(white: 0.5, alpha: 1)
            bar.tintColor = .label
            bar.keyboardType = .webSearch
            bar.searchTextField.allowsEditingTextAttributes = false
            bar.delegate = self
            input.addSubview(bar)
            self.bar = bar
            leftView = bar.searchTextField.leftView
            
            let find = UIButton()
            find.translatesAutoresizingMaskIntoConstraints = false
            find.setTitle(NSLocalizedString("Find", comment: ""), for: .normal)
            find.setTitleColor(.label, for: .normal)
            find.setTitleColor(.secondaryLabel, for: .highlighted)
            find.addTarget(self, action: #selector(self.find), for: .touchUpInside)
            input.addSubview(find)
            
            view.session.type.sink { [weak self] in
                self?.becomeFirstResponder()
            }.store(in: &subs)
            
            view.session.text.sink { [weak self] in
                self?.bar.text = $0
            }.store(in: &subs)
            
            bar.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor).isActive = true
            bar.rightAnchor.constraint(equalTo: find.leftAnchor).isActive = true
            bar.centerYAnchor.constraint(equalTo: input.centerYAnchor).isActive = true
            
            find.topAnchor.constraint(equalTo: input.topAnchor).isActive = true
            find.bottomAnchor.constraint(equalTo: input.bottomAnchor).isActive = true
            find.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor).isActive = true
            rightView = find.widthAnchor.constraint(equalToConstant: 0)
            rightView.isActive = true
        }
        
        @discardableResult override func becomeFirstResponder() -> Bool {
            DispatchQueue.main.async { [weak self] in
                self?.bar.becomeFirstResponder()
                self?.bar.searchTextField.selectAll(nil)
                self?.changed()
            }
            return super.becomeFirstResponder()
        }
        
        func searchBar(_: UISearchBar, textDidChange: String) {
            changed()
        }
        
        func searchBarShouldEndEditing(_: UISearchBar) -> Bool {
            editable = false
            return true
        }
        
        func searchBarTextDidEndEditing(_: UISearchBar) {
            editable = true
        }
        
        func searchBarSearchButtonClicked(_: UISearchBar) {
            bar.text.map {
                Defaults.engine.browse($0).map {
                    let url: URL
                    switch $0 {
                    case let .search(search):
                        url = search
                    case let .navigate(navigate):
                        url = navigate
                        bar.text = nil
                        changed()
                    }
                    
                    if view.session.page == nil {
                        view.session.page = .init(url: url)
                    } else {
                        view.session.browse.send(url)
                    }
                }
                bar.resignFirstResponder()
            }
        }
        
        func searchBarCancelButtonClicked(_: UISearchBar) {
            view.session.search = ""
            bar.resignFirstResponder()
        }
        
        func insertText(_: String) { }
        func deleteBackward() { }
        
        private func changed() {
            bar.text.map {
                if $0.isEmpty == true {
                    bar.setShowsCancelButton(true, animated: true)
                    bar.searchTextField.leftView = leftView
                    rightView.constant = 0
                } else {
                    bar.setShowsCancelButton(false, animated: true)
                    bar.searchTextField.leftView = nil
                    if view.session.page?.url != nil {
                        rightView.constant = 60
                    } else {
                        rightView.constant = 0
                    }
                }
                view.session.search = $0
            }
        }
        
        @objc private func find() {
            bar.resignFirstResponder()
            bar.text.map {
                view.session.find.send($0)
            }
        }
    }
}