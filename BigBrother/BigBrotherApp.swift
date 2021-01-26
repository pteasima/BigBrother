import Cocoa
import SwiftUI
import Introspect

private var windowSize: CGFloat = 512

@main
struct BigBrotherApp: App {
  var body: some Scene {
    WindowGroup {
      AppView()
        .frame(width: windowSize, height: 1)
    }
  }
}

struct UpdatePreview: EnvironmentKey {
  static var defaultValue: (Image) -> Void = { _ in }
}

struct AppView: View {
  var body: some View {
    VStack {
      
    }
    .showErrors(shouldPrint: true)
    .introspectNSWindow(customize: setup(appWindow:))
  }
  
  @State @Reference private var setupOnce: Once?
  func setup(appWindow: NSWindow) {
    setupOnce {
      appWindow.level = .floating
      appWindow.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isEnabled = false
      appWindow.hasShadow = false
      let previewWindow = NSWindow(contentViewController: NSHostingController(rootView: Group {
        VStack {
          Button(action: {}) {
            Text("Im a button.")
          }
//          image.map {
//            $0
//            .resizable()
//            .aspectRatio(contentMode: ContentMode.fit)
//          }
        }
        .frame(width: windowSize, height: windowSize)
      }))
      previewWindow.alphaValue = 0.8
      previewWindow.ignoresMouseEvents = true
      previewWindow.styleMask = .borderless
//      window.delegate = windowDelegate
      appWindow.addChildWindow(previewWindow, ordered: .below)
      previewWindow.setFrameOrigin(NSPoint(x: appWindow.frame.origin.x, y: appWindow.frame.origin.y - windowSize))
    }
  }
}

