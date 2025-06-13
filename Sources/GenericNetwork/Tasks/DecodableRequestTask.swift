import Foundation
import FunctionalSwift
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct DecodableURLRequestTask<Wrapped: URLRequestTaskAsync, Object: Decodable>: URLRequestTaskAsync where Wrapped.Body == Data {
    typealias Body = Object

    private let wrapped: Wrapped
    private let decoder: JSONDecoder

    init(wrapped: Wrapped,
         decoder: JSONDecoder = .init()) {
        self.wrapped = wrapped
        self.decoder = decoder
    }

    func perform(using request: URLRequest) async throws -> URLResponseContainer<Object> {
        let responseContainer = try await wrapped.perform(using: request)
        let obj = try decoder.decode(Body.self, from: responseContainer.body)
        return .init(response: responseContainer.response, body: obj)
    }
}

extension URLRequestTaskAsync {
    func with<T: Decodable>(decoder: JSONDecoder, type _: T.Type) -> DecodableURLRequestTask<Self, T> {
        .init(wrapped: self, decoder: decoder)
    }
}
