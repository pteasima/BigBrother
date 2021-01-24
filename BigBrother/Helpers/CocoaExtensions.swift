import Cocoa

extension NSRect {
  var center: NSPoint {
    .init(x: NSMidX(self), y: NSMidY(self))
  }
}
