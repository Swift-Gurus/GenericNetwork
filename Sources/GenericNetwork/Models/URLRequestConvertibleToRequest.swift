import Foundation

extension URLRequestConvertible {
    /**
     If URLRequestConvertible has an authority component (baseURL or port) and a path component,
     then the path must either begin with “/” or be an empty string.
     If the URLRequestConvertible does not have an authority component (baseURL or port) and has a path component,
     the path component must not start with “//”. If those requirements are not met, URLCreateError.noURL is thrown .
     */
    func urlRequest() throws -> URLRequest {
        var request = try createURLRequest(from: self)
        request.httpBody = body
        request.httpMethod = method.rawValue
        request.set(headers: self.headers)
        if #available(iOS 14.5, macOS 11.3, *) {
            #if !canImport(FoundationNetworking)
            request.assumesHTTP3Capable = assumesHTTP3Capable
            #endif
        }
        return request
    }

    private func createURLRequest(from request: URLRequestConvertible) throws -> URLRequest {
        guard let url = createComponents(from: request).url else {
            throw URLCreateError(baseURL)
        }

        return requestTimeout.map { .init(url: url, timeoutInterval: $0) } ??
            .init(url: url)
    }

    private func createComponents(from request: URLRequestConvertible) -> URLComponents {
        var components = tryFrom(url: request.baseURL) ?? URLComponents()

        components.host = components.host ?? request.baseURL.nonEmptyOrNil
        components.path = components.path.isEmpty ? (request.path ?? "") : components.path

        if !request.parameters.isEmpty {
            components.queryItems = components.queryItems ?? request.parameters.map(URLQueryItem.init)
        }
        components.scheme = components.scheme ?? request.scheme?.rawValue
        components.port = components.port ?? request.port

        return components
    }

    private func tryFrom(url: String) -> URLComponents? {
        let components = URLComponents(string: url)
        return components?.host == nil ? nil : components
    }
}
