import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLRequest {
    mutating func set(headers: [String: String]) {
        headers.keys.forEach { key in
            self.setValue(headers[key], forHTTPHeaderField: key)
        }
    }
}
