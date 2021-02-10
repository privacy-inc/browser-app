import SwiftUI

struct Searchbar: View {
    @Binding var session: Session
    @State private var stats = false
    @State private var settings = false
    @State private var detail = false
    
    var body: some View {
        if !session.typing {
            Spacer()
                .frame(height: 10)
            HStack {
                if session.page == nil {
                    Control.Circle(image: "eyeglasses") {
                        stats = true
                    }
                    .sheet(isPresented: $stats) {
                        Stats(session: $session)
                    }
                } else {
                    Menu {
                        Button(action: session.reload.send) {
                            Text("Reload")
                            Image(systemName: "arrow.clockwise")
                        }
                        
                        Button {
                            if session.error == nil {
                                if session.backwards {
                                    session.previous.send()
                                } else {
                                    session.page = nil
                                }
                            } else {
                                session.unerror.send()
                            }
                        } label: {
                            Text("Back")
                            Image(systemName: "chevron.left")
                        }
                        
                        Button(action: session.next.send) {
                            Text("Forward")
                            Image(systemName: "chevron.right")
                        }
                        .disabled(!session.forwards)
                        
                        Button {
                            detail = true
                        } label: {
                            Text("Menu")
                            Image(systemName: "line.horizontal.3")
                        }
                        
                    } label: {
                        Control.Circle.Shape(image: "plus", background: .background, pressed: false)
                    }
                    .sheet(isPresented: $detail) {
                        Detail(session: $session)
                    }
                }
                Control.Circle(image: "magnifyingglass", action: session.type.send)
                if session.page == nil {
                    Control.Circle(image: "slider.horizontal.3") {
                        settings = true
                    }
                    .sheet(isPresented: $settings) {
                        Settings(session: $session)
                    }
                } else {
                    Control.Circle(image: "xmark") {
                        session.page = nil
                    }
                }
            }
            Spacer()
                .frame(height: 10)
        }
        Field(session: $session)
            .frame(height: 0)
    }
}
