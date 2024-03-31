@testable import GenericNetwork
import XCTest
import XCTestToolKit

final class JSONDecoderTestCase: XCTestCase {
    private var sut = JSONDecoder()

    func test_returns_prettified_error_for_key_not_found() throws {
        let data = try ["name": "Name"].serializedData
        XCTAssertThrowsError {
            let _: MockDecodable = try sut.decode(from: data)
        } catchBlock: { error in
            XCTAssertTrue(error is DecodingErrorMessage)
            XCTAssertEqual("\(error)", DecodingErrorStrings.missingKey("number"))
        }
    }

    func test_returns_prettified_error_for_value_not_found() throws {
        let data = try ["name": nil].serializedData
        XCTAssertThrowsError {
            let _: MockDecodable = try sut.decode(from: data)
        } catchBlock: { error in
            XCTAssertTrue(error is DecodingErrorMessage)
            XCTAssertEqual("\(error)", DecodingErrorStrings.missingValue(["name"]))
        }
    }

    func test_returns_prettified_error_for_type_mismatch() throws {
        let data = try ["name": 1].serializedData
        XCTAssertThrowsError {
            let _: MockDecodable = try sut.decode(from: data)
        } catchBlock: { error in
            XCTAssertTrue(error is DecodingErrorMessage)
            XCTAssertEqual("\(error)", DecodingErrorStrings.missingType(["name"],
                                                                        expected: String.self))
        }
    }
}
