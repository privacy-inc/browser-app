import SwiftUI

extension Search {
    struct Bar: UIViewRepresentable, Tabber {
        @Binding var session: Session
        let id: UUID
        
        func makeCoordinator() -> Coordinator {
            .init(wrapper: self)
        }
        
        func makeUIView(context: Context) -> Coordinator {
            context.coordinator
        }
        
        func updateUIView(_: Coordinator, context: Context) { }
    }
}
