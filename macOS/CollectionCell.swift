import QuartzCore

class CollectionCell<I>: CALayer where I : CollectionItemInfo {
    var first = false
    
    var none: CGColor {
        .clear
    }
    
    var highlighted: CGColor {
        .clear
    }
    
    var pressed: CGColor {
        .clear
    }
    
    var item: CollectionItem<I>?
    
    required init?(coder: NSCoder) { nil }
    override init(layer: Any) { super.init(layer: layer) }
    required override init() {
        super.init()
    }
    
    final var state = CollectionCellState.none {
        didSet {
            switch state {
            case .none:
                backgroundColor = none
            case .highlighted:
                backgroundColor = highlighted
            case .pressed:
                backgroundColor = pressed
            }
        }
    }
    
    final override func hitTest(_: CGPoint) -> CALayer? {
        nil
    }
    
    final override class func defaultAction(forKey: String) -> CAAction? {
        NSNull()
    }
}
