import AppKit
import Combine

final class Window: NSWindow {
    private weak var progress: Progress!
    private var subs = Set<AnyCancellable>()
    private let id: UUID
    
    init(id: UUID) {
        self.id = id
        super.init(contentRect: .init(x: 0,
                                      y: 0,
                                      width: NSScreen.main!.frame.width * 0.5,
                                      height: NSScreen.main!.frame.height),
                   styleMask: [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView],
                   backing: .buffered,
                   defer: false)
        minSize = .init(width: 400, height: 200)
        toolbar = .init()
        titlebarAppearsTransparent = true
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
//        setFrameAutosaveName("Window")
        tabbingMode = .preferred
        tab.title = NSLocalizedString("Privacy", comment: "")
        
        let progress = Progress(id: id)
        contentView!.addSubview(progress)
        self.progress = progress
        
        progress.bottomAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor).isActive = true
        progress.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 1).isActive = true
        progress.rightAnchor.constraint(equalTo: contentView!.rightAnchor, constant: -1).isActive = true
        
        session
            .tab
            .map {
                $0.state(id)
            }
            .removeDuplicates()
            .sink { [weak self] in
                switch $0 {
                case .new:
                    self?.show(New(id: id))
                case .browse:
                    break
                case .error:
                    break
                }
            }
            .store(in: &subs)
        

//        let accesory = NSTitlebarAccessoryViewController()
//        accesory.view = .init()
//        accesory.layoutAttribute = .top
//        addTitlebarAccessoryViewController(accesory)
//
//        let sidebar = Sidebar()
//
//        sidebar.projects.click.sink { [weak self] in
//            self?.projects()
//        }.store(in: &subs)
//
//        sidebar.activity.click.sink { [weak self] in
//            self?.activity()
//        }.store(in: &subs)
//
//        sidebar.capacity.click.sink { [weak self] in
//            self?.capacity()
//        }.store(in: &subs)
//
//        contentView!.addSubview(sidebar)
//        self.sidebar = sidebar
//
//        sidebar.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
//        sidebar.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
//        sidebar.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
//
//        Session.capacity.sink { [weak self] in
//            self?.capacity()
//        }.store(in: &subs)
//
//        projects()
    }
    
    override func becomeMain() {
        super.becomeMain()
        dim(1)
    }
    
    override func resignMain() {
        super.resignMain()
        dim(0.4)
    }
    
//    private func projects() {
//        select(sidebar.projects)
//        show(Projects())
//        titlebarAccessoryViewControllers.first!.view = Projects.Titlebar()
//    }
//
//    private func activity() {
//        select(sidebar.activity)
//        show(Activity())
//        titlebarAccessoryViewControllers.first!.view = Activity.Titlebar()
//    }
//
//    private func capacity() {
//        select(sidebar.capacity)
//        show(Capacity())
//        titlebarAccessoryViewControllers.first!.view = Capacity.Titlebar()
//    }
    
//    private func show(_ view: NSView) {
//        contentView!.subviews.filter {
//            !($0 is Sidebar)
//        }.forEach {
//            $0.removeFromSuperview()
//        }
//
//        view.translatesAutoresizingMaskIntoConstraints = false
//        contentView!.addSubview(view)
//        view.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 1).isActive = true
//        view.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -1).isActive = true
//        view.leftAnchor.constraint(equalTo: sidebar.rightAnchor).isActive = true
//        view.rightAnchor.constraint(equalTo: contentView!.rightAnchor, constant: -1).isActive = true
//    }
//
//    private func select(_ item: Sidebar.Item) {
//        Session.edit.send(nil)
//        [sidebar.projects, sidebar.activity, sidebar.capacity].forEach {
//            $0.state = $0 == item ? .selected : .on
//        }
//    }
    
    private func show(_ view: NSView) {
        contentView!
            .subviews
            .filter {
                $0 != progress
            }
            .forEach {
                $0.removeFromSuperview()
            }
        
        view.wantsLayer = true
        view.layer!.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer!.cornerRadius = 9
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView!.addSubview(view)
        view.topAnchor.constraint(equalTo: progress.bottomAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -1).isActive = true
        view.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 1).isActive = true
        view.rightAnchor.constraint(equalTo: contentView!.rightAnchor, constant: -1).isActive = true
    }
    
    private func dim(_ opacity: CGFloat) {
//        (contentView!.subviews + [titlebarAccessoryViewControllers.first!.view]).forEach {
//            $0.alphaValue = opacity
//        }
    }
}
