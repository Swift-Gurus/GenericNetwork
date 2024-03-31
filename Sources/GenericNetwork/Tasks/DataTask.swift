import Foundation
import FunctionalSwift
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct RequestDataTask: URLRequestTaskAsync {
    private let session: URLSession
    private let responseAdapter = GenericResponseAdapter<Data>()

    init(session: URLSession) {
        self.session = session
    }

    func perform(using request: URLRequest) async throws -> URLResponseContainer<Data> {
        let (data, response) = try await session.data(using: request)
        return .init(response: response, body: data)
    }

    func perform(using request: URLRequest,
                 completion: @escaping ResultClosure<URLResponseContainer<Data>>) {
        session.dataTask(with: request) { [responseAdapter] data, response, error in
            let result = responseAdapter.getResponse(data: data,
                                                     response: response,
                                                     error: error,
                                                     originalRequest: request)
            completion(result)
        }
        .resume()
    }
}
