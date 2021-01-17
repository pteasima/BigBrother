import SwiftUI

// This replaces our BetterEnvironment dependency in an even more minimal way.
// We'll use this going forward but wont migrate old code yet (no time/reason to do it now)
extension EnvironmentValues {
  subscript<Key: EnvironmentKey>(keyPath: KeyPath<Key, Key>) -> Key.Value {
    get { self[Key.self] }
    set { self[Key.self] = newValue }
  }
}
