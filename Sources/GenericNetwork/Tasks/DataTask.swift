import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct RequestDataTask: URLRequestTask {
 
    private let session: URLSession
  
    init(session: URLSession) {
        self.session = session
    }
    
    func perform(using request: URLRequest) async throws -> URLResponseContainer<Data> {
        let (data, response) = try await session.data(using: request)
        return .init(response: response, body: data)
    }
    
    func load<T: Decodable>(request: URLRequestConvertible) async throws -> T {
       fatalError()
    }
}
