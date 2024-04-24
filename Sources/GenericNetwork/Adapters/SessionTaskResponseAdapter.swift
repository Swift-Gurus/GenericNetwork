import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
public enum GenericNetworkError<T>: Error {
    case noResponseNorData
    case serverError(NetworkResponse<T>)
    case system(error: Error)
}

class GenericResponseAdapter<T> {
    typealias Response = URLResponseContainer<T>

    func getResponse(data: T?,
                     response: URLResponse?,
                     error: Error?,
                     originalRequest: URLRequest) -> Result<URLResponseContainer<T>, Error> {
        if let error {
            return .failure(GenericNetworkError<T>.system(error: error))
        }

        guard let response, let data else {
            return .failure(GenericNetworkError<T>.noResponseNorData)
        }

        return .success(URLResponseContainer(response: response, body: data))
    }
}

extension GenericNetworkError: Equatable where T: Equatable {
    public static func == (lhs: GenericNetworkError<T>, rhs: GenericNetworkError<T>) -> Bool {
        switch (lhs, rhs) {
        case let (.system(ler), .system(rer)):
            return ler.localizedDescription == rer.localizedDescription

        case let (.serverError(ler), .serverError(rer)):
            return ler == rer

        case (.noResponseNorData, .noResponseNorData):
            return true

        default:
            return false
        }
    }
}
