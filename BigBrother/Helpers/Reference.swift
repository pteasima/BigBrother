@propertyWrapper struct Reference<Value> {
  init(wrappedValue: Value) {
    box = .init(value: wrappedValue)
  }
  private final class ReferenceBox {
    init(value: Value) { self.value = value }
    var value: Value
  }
  private var box: ReferenceBox
  var wrappedValue: Value {
    get { box.value }
    set { box.value = newValue }
  }
}

@propertyWrapper struct WeakReference<Value: AnyObject> {
  init(wrappedValue: Value?) {
    box = .init(value: wrappedValue)
  }
  private final class ReferenceBox {
    init(value: Value?) { self.value = value }
    weak var value: Value?
  }
  private var box: ReferenceBox
  var wrappedValue: Value? {
    get { box.value }
    set { box.value = newValue }
  }
}

