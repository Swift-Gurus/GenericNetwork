import Foundation
@testable import GenericNetwork

extension GenericNetwork {
    func downloadUsingResultApi(for type: F.RequestType, destination: URL) async throws -> URLResponseContainer<URL> {
       try await withCheckedThrowingContinuation { continuation in
            download(for: type, destination: destination) { continuation.resume(with: $0) }
       }
    }
}
