import SwiftUI
import Introspect

@main
struct BigBrotherApp: App {
  @State @Reference var previewWindow: NSWindow?
  @State var image: Image?
  var body: some Scene {
    WindowGroup {
      AppView()
        .environment(\.[\UpdatePreview.self], { image = $0 })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    WindowGroup("Preview") {
      VStack {
        image.map {
          $0
          .resizable()
          .aspectRatio(contentMode: ContentMode.fit)
        }
      }
      .introspectNSWindow { window in
        window.ignoresMouseEvents = true
        window.alphaValue = 0.8

        previewWindow = window
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .handlesExternalEvents(matching: Set(arrayLiteral: "*"))
  }
}

struct UpdatePreview: EnvironmentKey {
  static var defaultValue: (Image) -> Void = { _ in }
}

struct AppView: View {
  var background: Color = .clear
  var body: some View {
    VStack {
      TextEditor(text: .mock("empty"))
      ScreenRecorderView()
        .showErrors(shouldPrint: true)
        .background(background)
    }
    
  }
}
