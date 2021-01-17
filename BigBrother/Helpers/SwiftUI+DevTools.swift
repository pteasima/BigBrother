import SwiftUI

extension View {
  func dev<ModifiedView: View>(modifications: (Self) -> ModifiedView) -> some View {
    #if DEBUG
    return modifications(self)
    #else
    return self
    #endif
  }
}
