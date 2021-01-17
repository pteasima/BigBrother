import Foundation
import Combine
import SwiftUI

extension AnyCancellable {
  // Combine provides `store(in:)` sugar for collections of cancellables, but sometimes we wanna explicitly store them in optional variables (e.g. to ensure old request gets cancelled as new one gets made), so we have this sugar.
  func store(in target: inout AnyCancellable?) {
    target = self
  }
}

extension Publisher where Failure == Never {
  func assign(to: Binding<Output>) -> AnyCancellable {
    sink {
      to.wrappedValue = $0
    }
  }
  func assign(to: Binding<Output?>) -> AnyCancellable {
    sink {
      to.wrappedValue = $0
    }
  }
}

extension Optional where Wrapped: Cancellable {
  // in theory it should be enough to just set a Cancellable to `nil` and it should cancel itself
  // but its still best practice to explicitly call `cancel()` (can also help in case someone else retained it by accident)
  // this helper does it one go
  mutating func cancelAndRemove() {
    self?.cancel()
    self = nil
  }
}
