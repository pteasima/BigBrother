import XCTest
@testable import BigBrother

class OnceTests: XCTestCase {
  var once: Once?
  
  func testOnce() {
    var count: Int = 0
    once {
      count += 1
    }
    once {
      count += 1
    }
    XCTAssertEqual(count, 1)
  }
}
