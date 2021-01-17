import Foundation
import SwiftUI
import Combine

struct Throw: EnvironmentKey {
  static var defaultValue: Self = .init()
  
  var handleError: (Error) -> Void = { error in
    print("Unhandled user-facing error: \(error.localizedDescription) , \(error)")
    raise(SIGINT)
  }
  func callAsFunction(_ error: Error) {
    handleError(error)
  }
  func `try`(_ work: (() throws -> Void)) {
    do {
      try work()
    } catch {
      handleError(error)
    }
  }
}

extension Publisher {
  func sendErrors(to: Throw, completeOnError: Bool = true) ->  Publishers.Catch<Self, Publishers.HandleEvents<Empty<Self.Output, Never>>> {
    `catch` { error in
      Empty(completeImmediately: completeOnError)
        .handleEvents(receiveSubscription: { _ in
          to(error)
        })
    }
  }
}

fileprivate struct ShowErrors: ViewModifier {
  var shouldPrint: Bool
  @State private var errors: [Error] = []
  func body(content: Content) -> some View {
    content
      .environment(\.[\Throw.self], Throw { error in
        print("error: ", error, "description: ", error.localizedDescription)
        errors.append(error)
      })
  }
}

extension View {
  func showErrors(shouldPrint: Bool = false) -> some View {
    modifier(ShowErrors(shouldPrint: shouldPrint))
  }
}

