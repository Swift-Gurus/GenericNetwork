import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct RequestDataTask {
    private let session: URLSession
    private let responseAdapter: ResponseAdapter
    init(session: URLSession, responseAdapter: ResponseAdapter) {
        self.session = session
        self.responseAdapter = responseAdapter
    }
    func load<T: Decodable>(request: URLRequestConvertible) async throws -> T {
       let urlRequest = try request.urlRequest()
       let (data, response) = try await session.data(using: urlRequest)
       return try responseAdapter.response(for: data, response: response)
    }
}
