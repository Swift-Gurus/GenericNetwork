import Foundation

struct URLCreateError: LocalizedError {
    let baseURL: String

    var errorDescription: String? {
        "Could not create a request because URL is invalid: \(baseURL)"
    }

    init(_ baseURL: String) {
        self.baseURL = baseURL
    }
}
