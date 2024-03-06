import Foundation

struct DecodableRequestTask<Wrapped: NetworkTask, Object: Decodable>: NetworkTask where Wrapped.Body == Data {
 
    typealias Body = Object
    private let wrapped: Wrapped
    private let decoder: JSONDecoder
    init(wrapped: Wrapped,
         decoder: JSONDecoder = .init()) {
        self.wrapped = wrapped
        self.decoder = decoder
    }
    
    func perform(using request: URLRequestConvertible) async throws -> NetworkResponse<Body> {
        let responseContainer = try await wrapped.perform(using: request)
        let obj = try decoder.decode(Body.self, from: responseContainer.body)
        return .init(status: responseContainer.status, body: obj)
    }
    
}


extension RequestTask {
    func with<T: Decodable>(decoder: JSONDecoder, type: T.Type) -> DecodableRequestTask<Self, T> {
        .init(wrapped: self, decoder: decoder)
    }
}
