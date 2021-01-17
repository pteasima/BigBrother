import SwiftUI

private struct OnFirstAppear: ViewModifier {
  final class ReferenceState {
    var hasAppeared: Bool = false
  }
  @State var referenceState: ReferenceState = .init()
  var perform: () -> Void
  func body(content: Content) -> some View {
    content
      .onAppear {
        defer { referenceState.hasAppeared = true }
        guard !referenceState.hasAppeared else { return }
        perform()
      }
  }
}

extension View {
  func onFirstAppear(perform: @escaping () -> Void) -> some View {
    self.modifier(OnFirstAppear(perform: perform))
  }
}
