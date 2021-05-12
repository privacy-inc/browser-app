import SwiftUI

extension Tab.Bar {
    struct Search: View {
        @Binding var session: Session
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.tertiarySystemFill))
                Image(systemName: "magnifyingglass")
            }
            .frame(width: 60)
            .onTapGesture {
                session.section = session.section.search
            }
        }
    }
}
