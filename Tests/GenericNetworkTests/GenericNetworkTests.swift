import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@testable import GenericNetwork
import Testing
import XCTest
import XCTestToolKit

@Suite(.serialized)
struct GenericNetworkTests {
    let networkMonitor = NetworkTestMonitor()
    var factory: FactoryMock {
        FactoryMock()
    }
    let fileMoverMock = FileMoverMock()
    var defaultExpectedDecodable: MockDecodable { .init(name: "Name", number: 100) }
    var fakeRequestType: String { "fakeRequest" }
    let notFoundCode = 400
    var defaultMockDecodableData: Data {
        get throws {
           try [
                "name": "Name",
                "number": 100
           ].serializedData
        }
    }
    var sut: GenericNetwork<FactoryMock> {
        .init(
            factory: factory,
            urlSession: networkMonitor.mockSession,
            fileMover: fileMoverMock
        )
    }

    var destination: URL { FileManager.default.temporaryDirectory }

    @Test("Validate returns proper decoded object")
    func test_returns_decoded_object() async throws {
        try addDefaultStubAndSetConfirmation()
        let object: URLResponseContainer<MockDecodable> = try await sut.decodable(for: fakeRequestType)
        #expect(object.body == defaultExpectedDecodable)
        try await #expect(networkMonitor.allRequests.count == 1)
    }

    @Test("Validates that file is downloaded and moved")
    func test_downloads_file_and_ask_the_mover() async throws {
        try addDefaultStubAndSetConfirmation()
        let urlResponse: URLResponseContainer<URL> = try await sut.download(for: fakeRequestType,
                                                                            destination: destination)

        #expect(urlResponse.body == destination)
        #expect(fileMoverMock.destinations == [destination])
        try await #expect(networkMonitor.allRequests.count == 1)
    }

    @Test("Validates that download fails if mover fails")
    func test_download_fails_if_mover_fails() async throws {
        try addDefaultStubAndSetConfirmation()
        fileMoverMock.expectedError = DefaultMockError()
        await #expect(throws: Error.self) {
            _ = try await sut.download(for: fakeRequestType, destination: destination)
        }
        try await #expect(networkMonitor.allRequests.count == 1)
    }

    @Test("Validates that data fetch fails if serialization fails")
    func test_throws_error_if_serialization_fails() async throws {
        let stub = URLProtocolResponseStub(data: Data())
        networkMonitor.addStubs([stub])
        networkMonitor.setObserveRequests(1)

        await #expect(throws: Error.self) {
            let _: URLResponseContainer<MockDecodable> = try await sut.decodable(for: fakeRequestType)
        }
        try await #expect(networkMonitor.allRequests.count == 1)
    }

    @Test("Validates that data fetch fails if response code is not success")
    func test_throws_error_if_not_success_code() async throws {
        let stub = URLProtocolResponseStub(data: Data(), status: notFoundCode)
        networkMonitor.addStubs([stub])
        networkMonitor.setObserveRequests(1)

        await XCTAssertThrowsErrorAsync {
            let _: URLResponseContainer<MockDecodable> = try await sut.decodable(for: fakeRequestType)
        } catchBlock: { error in
            XCTAssertEqual(error.getNetworkError(),
                           expectedError(with: notFoundCode))
        }

        try await #expect(networkMonitor.allRequests.count == 1)
    }

    private func addDefaultStubAndSetConfirmation() throws {
        try networkMonitor.addStubs([.init(data: defaultMockDecodableData)])
        networkMonitor.setObserveRequests(1)
    }

    private func expectedError(with code: Int) -> GenericNetworkError<Data> {
        .serverError(NetworkResponse<Data>(status: code, body: .init()))
    }
}
