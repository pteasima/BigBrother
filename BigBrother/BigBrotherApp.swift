import Cocoa
import SwiftUI
import Introspect

@main
struct BigBrotherApp: App {
  @State @WeakReference var previewWindow: NSWindow?
  @State var image: Image?
  
  final class WindowDelegate: NSObject, ObservableObject, NSWindowDelegate {
    @Published var frame: NSRect?
    @Published var overlapping: String?
    func windowDidMove(_ notification: Notification) {
      guard let window = notification.object as? NSWindow
      else { assertionFailure(); return}
      frame = window.frame
      let center = window.frame.center
      
      guard let windowList = CGWindowListCopyWindowInfo(.optionAll, kCGNullWindowID) as? [[CFString: Any]]
      else { assertionFailure(); return }
      
      
      print(windowList.compactMap(WindowInfo.init(dictionaryRepresentation:))
              .filter { $0.bounds.contains(center) }
//              .filter { $0.name != "Preview"}
//              .first { windowInfo in
//        windowInfo.bounds.contains(center)
              .map(\.name)
              .first
//      }
      )
      
//      print(windowList?.compactMap { windowInfo -> CGRect? in
//        CGRect(dictionaryRepresentation: windowInfo[kCGWindowBounds] as! CFDictionary)
//      })
    }
  }
  @StateObject var windowDelegate: WindowDelegate = .init()
  var body: some Scene {
    WindowGroup {
      AppView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .dev { appView in
          VStack {
            Text(String(describing: windowDelegate.frame))
            appView
          }
        }
    }
//    WindowGroup("Preview") {
//      VStack {
//        Button(action: onTap) {
//          Text("Im a button.")
//        }
//        image.map {
//          $0
//          .resizable()
//          .aspectRatio(contentMode: ContentMode.fit)
//        }
//      }
////      .introspectNSWindow { window in
//////        window.ignoresMouseEvents = true
////        guard previewWindow == nil || previewWindow == window
////        else {
//////          window.close()
////          return
////        }
////
////        window.alphaValue = 0.8
////        window.orderFrontRegardless()
////        window.delegate = windowDelegate
////        previewWindow = window
////      }
//      .frame(width: 512, height: 512)
//    }
//    .handlesExternalEvents(matching: ["preview"])
  }
  
  func onTap() {
    
  }
}

struct UpdatePreview: EnvironmentKey {
  static var defaultValue: (Image) -> Void = { _ in }
}

struct AppView: View {
  @State var image: Image?
  var background: Color = .clear
  var body: some View {
    VStack {
      TextEditor(text: .mock("empty"))
      ScreenRecorderView()
        .environment(\.[\UpdatePreview.self], { image = $0 })
        .showErrors(shouldPrint: true)
        .background(background)
    }
    .introspectNSWindow(customize: setup(window:))
  }
  
  @State @Reference private var setupOnce: Once?
  func setup(window: NSWindow) {
    setupOnce {
      let child = NSWindow(contentViewController: NSHostingController(rootView: Group {
        VStack {
          Button(action: {}) {
            Text("Im a button.")
          }
          image.map {
            $0
            .resizable()
            .aspectRatio(contentMode: ContentMode.fit)
          }
        }
        .frame(width: 500, height: 500)
      }))
      window.addChildWindow(child, ordered: .above)
    }
  }
}

