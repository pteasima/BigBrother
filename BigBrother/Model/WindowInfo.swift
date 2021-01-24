import Cocoa

struct WindowInfo {
  var bounds: CGRect
  var name: String
}

extension WindowInfo {
  init?(dictionaryRepresentation: [CFString: Any]) {
    guard let bounds = dictionaryRepresentation[kCGWindowBounds].flatMap({ CGRect(dictionaryRepresentation: $0 as! CFDictionary)}),
          let name = dictionaryRepresentation[kCGWindowOwnerName] as? String,
    true == (dictionaryRepresentation[kCGWindowIsOnscreen] as? Bool)
    else { return nil }
    self.init(bounds: bounds, name: name)
  }
}
