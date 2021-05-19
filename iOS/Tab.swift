import SwiftUI

struct Tab: View {
    @Binding var session: Session
    let id: UUID
    @State private var modal = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                switch session.tab.state(id) {
                case .new:
                    New(session: $session, id: id)
                case .browse:
                    Web(session: $session, id: id, tabs: tabs)
                        .edgesIgnoringSafeArea([.top, .leading, .trailing])
                case let .error:
                    Circle()
                }
                Rectangle()
                    .fill(Color(.tertiaryLabel))
                    .frame(height: 1)
                Bar(session: $session, modal: $modal, id: id, tabs: tabs)
            }
            Modal(session: $session, show: $modal, id: id)
            session
                .toast
                .map {
                    Toast(session: $session, message: $0)
                }
        }
    }
    
    private func tabs() {
        withAnimation(.spring(blendDuration: 0.4)) {
            session.section = .tabs(id)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            snapshot()
        }
    }
    
    private func snapshot() {
        let controller = UIHostingController(rootView: self)
        controller.view!.bounds = .init(origin: .zero, size: UIScreen.main.bounds.size)
        session.tab[snapshot: id] = UIGraphicsImageRenderer(size: UIScreen.main.bounds.size)
            .pngData { _ in
                controller.view!.drawHierarchy(in: UIScreen.main.bounds, afterScreenUpdates: true)
            }
    }
}
