import WebKit
import Combine
import Sleuth

final class Web: Webview {
    private var destination = Destination.window
    
    required init?(coder: NSCoder) { nil }
    init(id: UUID, browse: Int) {
        var settings = cloud.archive.value.settings
        
        if !App.dark {
            settings.dark = false
        }
        
        let handler = Handler()
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.preferredContentMode = .desktop
        configuration.preferences.setValue(true, forKey: "fullScreenEnabled")
        configuration.userContentController.add(handler, name: "handler")
        
        super.init(configuration: configuration, id: id, browse: browse, settings: settings)
        setValue(false, forKey: "drawsBackground")
        customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15"
        handler.web = self
        
        session
            .load
            .filter {
                $0.id == id
            }
            .sink { [weak self] in
                self?.load($0.access)
            }
            .store(in: &subs)
        
        session
            .reload
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                self?.reload()
            }
            .store(in: &subs)
        
        session
            .stop
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                self?.stopLoading()
            }
            .store(in: &subs)
        
        session
            .back
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                self?.goBack()
            }
            .store(in: &subs)
        
        session
            .forward
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                self?.goForward()
            }
            .store(in: &subs)
        
        session
            .print
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
//                UIPrintInteractionController.shared.printFormatter = self?.viewPrintFormatter()
//                UIPrintInteractionController.shared.present(animated: true)
            }
            .store(in: &subs)

        session
            .pdf
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                self?.createPDF {
                    guard
                        case let .success(data) = $0,
                        let name = self?.url?.file("pdf")
                    else { return }
//                    UIApplication.shared.share(data.temporal(name))
                }
            }
            .store(in: &subs)
        
        session
            .webarchive
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                self?.createWebArchiveData {
                    guard
                        case let .success(data) = $0,
                        let name = self?.url?.file("webarchive")
                    else { return }
//                    UIApplication.shared.share(data.temporal(name))
                }
            }
            .store(in: &subs)
        
        session
            .snapshot
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                self?.takeSnapshot(with: nil) { image, _ in
//                    guard
//                        let data = image?.pngData(),
//                        let name = self?.url?.file("png")
//                    else { return }
//                    UIApplication.shared.share(data.temporal(name))
                }
            }
            .store(in: &subs)
        
        session
            .find
            .filter {
                $0.0 == id
            }
            .map {
                $0.1
            }
            .sink { [weak self] in
                self?.find($0) {
                    guard $0.matchFound else { return }
                    self?.evaluateJavaScript(Script.highlight) { offset, _ in
                        offset
                            .flatMap {
                                $0 as? CGFloat
                            }
                            .map {
                                self?.found($0)
                            }
                    }
                }
            }
            .store(in: &subs)
    }
    
    override func external(_ url: URL) {
        NSWorkspace.shared.open(url)
    }
    
    func webView(_: WKWebView, createWebViewWith: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
//        if action.targetFrame == nil && action.navigationType == .other {
//            action.request.url.map { new in
//                switch destination {
//                case .window:
//                    (NSApp as? App)?.window(new)
//                case .tab:
//                    (window as? Window)?.newTab(new)
//                case .download:
//                    URLSession.shared.dataTaskPublisher(for: new)
//                        .map(\.data)
//                        .receive(on: DispatchQueue.main)
//                        .replaceError(with: .init())
//                        .sink { [weak self] in
//                            (self?.window as? Window)?.save(new.lastPathComponent, data: $0)
//                        }.store(in: &subs)
//                    break
//                }
//                destination = .window
//            }
//        } else if action.navigationType == .linkActivated {
//            action.request.url.map {
//                (window as? Window)?.newTab($0)
//            }
//        }
        return nil
    }
    
    override func willOpenMenu(_ menu: NSMenu, with: NSEvent) {
        menu.items.first { $0.identifier?.rawValue == "WKMenuItemIdentifierOpenLinkInNewWindow" }.map { item in
            let newTab = NSMenuItem(title: NSLocalizedString("Open Link in New Tab", comment: ""), action: #selector(tabbed), keyEquivalent: "")
            newTab.target = self
            newTab.representedObject = item
            menu.items = [newTab, .separator()] + menu.items
            
            menu.items.first { $0.identifier?.rawValue == "WKMenuItemIdentifierDownloadLinkedFile" }.map {
                $0.target = self
                $0.action = #selector(download)
                $0.representedObject = item
            }
        }
        menu.items.first { $0.identifier?.rawValue == "WKMenuItemIdentifierOpenImageInNewWindow" }.map { item in
            let newTab = NSMenuItem(title: NSLocalizedString("Open Image in New Tab", comment: ""), action: #selector(tabbed), keyEquivalent: "")
            newTab.target = self
            newTab.representedObject = item
            menu.insertItem(newTab, at: menu.items.firstIndex(of: item)!)
            
            menu.items.first { $0.identifier?.rawValue == "WKMenuItemIdentifierDownloadImage" }.map {
                $0.target = self
                $0.action = #selector(download)
                $0.representedObject = item
            }
        }
    }
    
    private func found(_ offset: CGFloat) {
//        scrollView.scrollRectToVisible(.init(x: 0,
//                                             y: offset + scrollView.contentOffset.y - (offset > 0 ? 160 : -180),
//                                             width: 320,
//                                             height: 320),
//                                       animated: true)
    }
    
    @objc private func tabbed(_ item: NSMenuItem) {
//        destination = .tab
//        item.synth()
    }
    
    @objc private func download(_ item: NSMenuItem) {
//        destination = .download
//        item.synth()
    }
}
