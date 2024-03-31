import Foundation
@testable import GenericNetwork

struct MockRequest: URLRequestConvertible, Equatable {
    static var expectedFullBaseURLString: String {
        "https://baseURL.com:980/path?id=id"
    }

    static var expectedURLString: String {
        "https://www.myApi.com:980/console"
    }

    static var emptyRequest: Self {
        var request = Self(baseURL: "")
        request.path = nil
        request.parameters = [:]
        request.headers = [:]
        request.scheme = nil
        request.port = nil
        request.body = nil
        return request
    }

    var baseURL: String = "www.myApi.com"
    var path: String? = "/console"
    var parameters: [String: String] =
         ["role": "admin", "access": "full"]

    var headers: [String: String] = ["username": "admin", "password": "12345"]

    var body: Data? = {
        guard let data = "Test".data(using: .utf8) else {
            fatalError("Could not create data")
        }
        return data
    }()

    var method: RequestMethod = .get
    var scheme: RequestScheme? = .https
    var port: Int? = 980
    var requestTimeout: TimeInterval? = 60
    var id: String = UUID().uuidString

    var requestPolicyTag: Int = 0
    var assumesHTTP3Capable = false
    var requestType: String?
}
