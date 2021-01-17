import Foundation

extension URL {
  static let documentsDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}
