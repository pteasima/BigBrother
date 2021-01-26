struct Once {
  fileprivate init() { }
}

extension Optional where Wrapped == Once {
  mutating func callAsFunction(_ work: () -> Void) {
    switch self {
    case .none:
      self = .some(.init())
      work()
    case .some:
      break // already ran
    }
  }
}

