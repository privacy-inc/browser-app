import SwiftUI

struct Window: View {
    @Binding var session: Session
    @State private var progress = CGFloat()
    
    var body: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
//                VStack {
                    
//                    Spacer()
//                }
//                if session.state.error != nil {
//                    VStack {
//                        Image(systemName: "exclamationmark.triangle.fill")
//                            .font(Font.largeTitle.bold())
//                            .foregroundColor(.accentColor)
//                        Text(verbatim: session.page?.url.absoluteString ?? "")
//                            .multilineTextAlignment(.center)
//                            .font(.footnote)
//                            .foregroundColor(.secondary)
//                            .padding()
//                        Text(verbatim: session.state.error!)
//                            .padding(.horizontal)
//                            .multilineTextAlignment(.center)
//                    }
//                }
                if session.browser.page.value == nil {
                    History()
                } else {
                    Web(session: $session)
                    if !session.typing {
                        Progress(progress: progress)
                    }
                }
                Searchbar(session: $session)
            }
            .edgesIgnoringSafeArea(.top)
        }
        .onReceive(session.browser.browse) {
            guard session.browser.page.value == nil else { return }
            session.browser.page.value = .init(url: $0)
        }
        .onReceive(session.browser.progress) {
            progress = .init($0)
        }
    }
}
