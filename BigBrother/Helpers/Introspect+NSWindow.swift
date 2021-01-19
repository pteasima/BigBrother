import SwiftUI
import Introspect

extension View {
  func introspectNSWindow(customize: @escaping (NSWindow) -> Void) -> some View {
    introspect(selector: { $0 }) {
      if let window = $0.window {
        customize(window)
      }
    }
  }
}

