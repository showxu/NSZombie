import XCTest
@testable import NSZombie

@objcMembers class TestClass: NSObject {
    
    @objc dynamic func sprintf() {
        print(NSStringFromClass(TestClass.self))
    }
}

final class NSZombieTests: XCTestCase {
    
    func testDealloc() {
        let exp = expectation(description: "Wait for dealloc.")
        DispatchQueue.main.async {
            let object = TestClass()
            DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime.now() + 2) { [unowned object] in
                object.sprintf()
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error)
        }
    }

    static var allTests = [
        ("testExample", testDealloc),
    ]
}
