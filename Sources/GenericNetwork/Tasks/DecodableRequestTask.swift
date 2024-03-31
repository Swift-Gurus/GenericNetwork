import Foundation
import FunctionalSwift

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

    func perform(using request: URLRequest, completion: @escaping ResultClosure<URLResponseContainer<Object>>) {
        wrapped.perform(using: request) {  [decoder] response in
            response.tryMap { value in .init(response: value.response, body: try decoder.decode(Body.self, from: value.body)) }
                    .sink(completion)
        }
    }
}

extension URLRequestTaskAsync {
    func with<T: Decodable>(decoder: JSONDecoder, type: T.Type) -> DecodableURLRequestTask<Self, T> {
        .init(wrapped: self, decoder: decoder)
    }
}
