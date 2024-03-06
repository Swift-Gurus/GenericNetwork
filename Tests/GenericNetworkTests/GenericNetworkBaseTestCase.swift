import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import XCTest
import XCTestToolKit
@testable import GenericNetwork

class GenericNetworkBaseTestCase<F: RequestFactory>: XCTestCase {
    var fileMoverMock = FileMoverMock()
    var successCode: [Int] = [200]
    var sessionConfiguration: URLSessionConfiguration = .default
    var fakeRequestType: F.RequestType { fatalError() }
    var mockSession: URLSession { URLSession(configuration: sessionConfiguration) }
    var destination: URL { FileManager.default.temporaryDirectory }
    func expectedError(with code: Int) -> NetworkResponse<Data> {  .init(status: code, body: .init()) }
    
    var factory: F {
        fatalError()
    }
    
    var sut: GenericNetwork<F> {
        .init(urlSession: mockSession,
              factory: factory,
              fileMover: fileMoverMock)
    }
    
    override func setUp() async throws {
        await URLProtocolStubBase.clear()
        sessionConfiguration = .default
        sessionConfiguration.protocolClasses = [URLProtocolStubBase.self]
        fileMoverMock = .init()
    }
    
    override func tearDown() async throws {
        await URLProtocolStubBase.clear()
    }
    
    func test_returns_decoded_object() async throws {
        let stub = try URLProtocolResponseStub(data: ["name": "name"].serializedData)
        await addStub(stub)
        let object: NetworkResponse<ExpectedStruct> = try await sut.data(for: fakeRequestType)
        XCTAssertEqual(object.body.name, "name")
    }
    
    func test_downloads_file_and_ask_the_mover() async throws {
        let stub = try URLProtocolResponseStub(data: ["name": "name"].serializedData)
        await addStub(stub)
        let urlResponse: NetworkResponse<URL> = try await sut.download(for: fakeRequestType,
                                                                       destination: destination)
        XCTAssertEqual(urlResponse.body, destination)
    }
    
    func test_throws_error_if_serialization_fails() async throws  {
        let stub = URLProtocolResponseStub(data: Data())
        await addStub(stub)
        
        await XCTAssertThrowsErrorAsync {
            let _: NetworkResponse<ExpectedStruct> = try await sut.data(for: fakeRequestType)
        }
       
    }
    
    
    func test_throws_error_if_not_success_code() async throws {
        let stub = URLProtocolResponseStub(data: Data(), status: 400)
        await addStub(stub)
        
        await XCTAssertThrowsErrorAsync {
            let _: NetworkResponse<ExpectedStruct> = try await sut.data(for: fakeRequestType)
        } catchBlock: { error in
            XCTAssertEqual(error.getNetworkError(), self.expectedError(with: 400))
        }
    }
    
}

extension GenericNetworkBaseTestCase {
    func addStub(_ stub: URLProtocolResponseStub) async {
        await URLProtocolStubBase.addExpectedStub(stub)
    }
}


extension NetworkResponse: Equatable where T: Equatable {
    public static func == (lhs: NetworkResponse, rhs: NetworkResponse) -> Bool {
        lhs.body == rhs.body && lhs.status == rhs.status
    }
}

extension Error {
    func getNetworkError<T: Decodable>() -> NetworkResponse<T>? {
        self as? NetworkResponse<T>
    }
}



private struct ExpectedStruct: Decodable {
    let name: String
}
