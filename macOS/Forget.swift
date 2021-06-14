import AppKit
import Combine

final class Forget: NSPopover {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        behavior = .semitransient
        contentSize = .init(width: 200, height: 260)
        contentViewController = .init()
        contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
        
        let title = Text()
        title.stringValue = NSLocalizedString("FORGET", comment: "")
        title.font = .preferredFont(forTextStyle: .footnote)
        title.textColor = .secondaryLabelColor

        let cache = Option.Basic(title: "Cache", image: "trash")
        cache
            .click
            .sink { [weak self] in
                Webview.clear()
                Toast.show(message: .init(title: "Deleted cache", icon: "trash.fill"))
                self?.close()
            }
            .store(in: &subs)
        
        let history = Option.Basic(title: "History", image: "clock")
        history
            .click
            .sink { [weak self] in
                cloud.forgetBrowse()
                Toast.show(message: .init(title: "Deleted history", icon: "clock.fill"))
                self?.close()
            }
            .store(in: &subs)
        
        let activity = Option.Basic(title: "Activity", image: "chart.bar.xaxis")
        activity
            .click
            .sink { [weak self] in
                cloud.forgetActivity()
                Toast.show(message: .init(title: "Deleted activity", icon: "chart.bar.xaxis"))
                self?.close()
            }
            .store(in: &subs)
        
        let trackers = Option.Basic(title: "Trackers", image: "shield.lefthalf.fill")
        trackers
            .click
            .sink { [weak self] in
                cloud.forgetBlocked()
                Toast.show(message: .init(title: "Deleted trackers", icon: "shield.lefthalf.fill"))
                self?.close()
            }
            .store(in: &subs)
        
        let everything = Option.Destructive(title: "Everything", image: "flame.fill")
        everything
            .click
            .sink { [weak self] in
                Webview.clear()
                cloud.forget()
                Toast.show(message: .init(title: "Deleted everything", icon: "flame.fill"))
                self?.close()
            }
            .store(in: &subs)
        
        var top = contentViewController!.view
        [title, cache, history, activity, trackers, everything]
            .forEach {
                contentViewController!.view.addSubview($0)
                $0.topAnchor.constraint(equalTo: top == contentViewController!.view ? top.topAnchor : top.bottomAnchor, constant:
                                            top == contentViewController!.view
                                            ? 30
                                            : top is Text
                                                ? 10
                                                : 5).isActive = true
                top = $0
            }
        
        [cache, history, activity, trackers, everything]
            .forEach {
                $0.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
            }
        
        title.leftAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor, constant: -60).isActive = true
    }
}