import SwiftUI
import Introspect

@main
struct BigBrotherApp: App {
  @State var introspected: Bool = false
  var body: some Scene {
    WindowGroup {
      AppView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //TODO: make the window resizable (when I introspect the NSWindow, it claims its already resizable, but its not
        //.frame(maxWidth: NSScreen.main.map { $0.frame.width - 100 }, maxHeight: NSScreen.main.map { $0.frame.height - 200 })
    }
  }
}

struct AppView: View {
  var body: some View {
    ScreenRecorderView()
//    Text("resizable text")
      .showErrors(shouldPrint: true)
  }
}
