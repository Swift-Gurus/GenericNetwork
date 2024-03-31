import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@testable import GenericNetwork
import XCTest
import XCTestToolKit

class GenericNetworkBaseTestCase<F: RequestFactory>: NetworkBaseTestsCase {
    let notFoundCode = 400

    var fileMoverMock = FileMoverMock()
    var fakeRequestType: F.RequestType { fatalError("Subclasses must implement") }
    var destination: URL { FileManager.default.temporaryDirectory }

    var factory: F {
        fatalError("Subclasses must implement")
    }

    var sut: GenericNetwork<F> {
        .init(factory: factory,
              urlSession: mockSession,
              fileMover: fileMoverMock)
    }

    var defaultMockDecodableData: Data {
        get throws {
           try [
                "name": "Name",
                "number": 100
           ].serializedData
        }
    }

    var defaultExpectedDecodable: MockDecodable { .init(name: "Name", number: 100) }

    override func setUp() async throws {
        try await super.setUp()
        await URLProtocolStubBase.clear()
        sessionConfiguration = .default
        sessionConfiguration.protocolClasses = [URLProtocolStubBase.self]
        fileMoverMock = .init()
    }

    override func tearDown() async throws {
        await URLProtocolStubBase.clear()
    }

    func test_returns_decoded_object() async throws {
        let stub = try URLProtocolResponseStub(data: defaultMockDecodableData)
        await addStub(stub)
        let object: URLResponseContainer<MockDecodable> = try await sut.data(for: fakeRequestType)
        XCTAssertEqual(object.body.name, defaultExpectedDecodable.name)
    }

    func test_returns_decoded_object_result_api() async throws {
        try await addDefaultStub()
        let object: URLResponseContainer<MockDecodable> = try await sut.data(for: fakeRequestType)
        XCTAssertEqual(object.body.name, defaultExpectedDecodable.name)
    }

    func test_downloads_file_and_ask_the_mover() async throws {
        try await addDefaultStub()
        let urlResponse: URLResponseContainer<URL> = try await sut.download(for: fakeRequestType,
                                                                            destination: destination)
        XCTAssertEqual(urlResponse.body, destination)
        XCTAssertEqual(fileMoverMock.destinations, [destination])
    }

    func test_downloads_file_and_ask_the_mover_result_api() async throws {
        try await addDefaultStub()
        let response = try await sut.downloadUsingResultApi(for: fakeRequestType, destination: destination)

        XCTAssertEqual(response.body, destination)
        XCTAssertEqual(fileMoverMock.destinations, [destination])
    }

    func test_download_fails_if_mover_fails_result_api() async throws {
        try await addDefaultStub()
        fileMoverMock.expectedError = DefaultMockError()
        await XCTAssertThrowsErrorAsync {
            _ = try await sut.downloadUsingResultApi(for: fakeRequestType, destination: destination)
        }
    }

    func test_download_fails_if_mover_fails() async throws {
        try await addDefaultStub()
        fileMoverMock.expectedError = DefaultMockError()
        await XCTAssertThrowsErrorAsync {
            _ = try await sut.download(for: fakeRequestType, destination: destination)
        }
    }

    func test_throws_error_if_serialization_fails() async throws {
        let stub = URLProtocolResponseStub(data: Data())
        await addStub(stub)

        await XCTAssertThrowsErrorAsync {
            let _: URLResponseContainer<MockDecodable> = try await sut.data(for: fakeRequestType)
        }
    }

    func test_throws_error_if_not_success_code() async throws {
        let stub = URLProtocolResponseStub(data: Data(), status: notFoundCode)
        await addStub(stub)

        await XCTAssertThrowsErrorAsync {
            let _: URLResponseContainer<MockDecodable> = try await sut.data(for: fakeRequestType)
        } catchBlock: { error in
            XCTAssertEqual(error.getNetworkError(), self.expectedError(with: self.notFoundCode))
        }
    }

    private func expectedError(with code: Int) -> GenericNetworkError<Data> {
        .serverError(NetworkResponse<Data>(status: code, body: .init()))
    }

    private func addDefaultStub() async throws {
        try await addStub(URLProtocolResponseStub(data: defaultMockDecodableData))
    }
}
