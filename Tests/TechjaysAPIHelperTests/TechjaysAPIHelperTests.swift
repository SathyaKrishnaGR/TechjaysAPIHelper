    import XCTest
    @testable import TechjaysAPIHelper

    final class TechjaysAPIHelperTests: XCTestCase {
        func testExample() {
            // This is an example of a functional test case.
            // Use XCTAssert and related functions to verify your tests produce the correct
            // results.
            XCTAssertEqual(TechjaysAPIHelper(appKeys: AppKeys.init()).text, "Hello, World!")
        }
    }
