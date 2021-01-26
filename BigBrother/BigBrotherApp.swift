import Cocoa
import SwiftUI
import Introspect

private var windowSize: CGFloat = 512

@main
struct BigBrotherApp: App {
  var body: some Scene {
    WindowGroup {
      AppView()
    }
  }
}

struct UpdatePreview: EnvironmentKey {
  static var defaultValue: (Image) -> Void = { _ in }
}

struct AppView: View {
  @StateObject private var windowManager: WindowManager = .init()
  
  var body: some View {
    Group { }
    .frame(width: windowSize, height: 1)
    .showErrors(shouldPrint: true)
      .introspectNSWindow(customize: windowManager.setup(appWindow:))
  }
}

struct PreviewView: View {
  @ObservedObject var windowManager: WindowManager
  var body: some View {
    Text(windowManager.overlapping ?? "none")
  }
}

final class WindowManager: NSObject, ObservableObject, NSWindowDelegate {
  private var frame: NSRect?
  @Published var overlapping: String?
  func windowDidMove(_ notification: Notification) {
    guard let window = notification.object as? NSWindow
    else { assertionFailure(); return}
    frame = window.frame
    let center = window.frame.center
    
    guard let windowList = CGWindowListCopyWindowInfo(.optionAll, kCGNullWindowID) as? [[CFString: Any]]
    else { assertionFailure(); return }
    
    
    overlapping = windowList.compactMap(WindowInfo.init(dictionaryRepresentation:))
            .filter { $0.bounds.contains(center) }
//              .filter { $0.name != "Preview"}
//              .first { windowInfo in
//        windowInfo.bounds.contains(center)
            .map(\.name)
            .first
  }
  
  private var setupOnce: Once?
  func setup(appWindow: NSWindow) {
    setupOnce {
      appWindow.level = .floating
      appWindow.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isEnabled = false
      appWindow.hasShadow = false
      let previewWindow = NSWindow(contentViewController: NSHostingController(rootView:
                                                                                PreviewView(windowManager: self)
        .frame(width: windowSize, height: windowSize)
      ))
      previewWindow.alphaValue = 0.8
      previewWindow.ignoresMouseEvents = true
      previewWindow.styleMask = .borderless
      previewWindow.delegate = self
      appWindow.addChildWindow(previewWindow, ordered: .below)
      previewWindow.setFrameOrigin(NSPoint(x: appWindow.frame.origin.x, y: appWindow.frame.origin.y - windowSize))
    }
  }
}
