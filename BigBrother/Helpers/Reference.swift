@propertyWrapper struct Reference<Value> {
  init(wrappedValue: Value) {
    projectedValue = .init(value: wrappedValue)
  }
  final class ReferenceBox {
    init(value: Value) { self.value = value }
    var value: Value
  }
  var projectedValue: ReferenceBox
  var wrappedValue: Value {
    get { projectedValue.value }
    set { projectedValue.value = newValue }
  }
}
