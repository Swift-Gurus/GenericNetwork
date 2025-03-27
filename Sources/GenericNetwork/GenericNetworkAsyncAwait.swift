import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension GenericNetwork {
    /// Returns Decodable object
    /// - Parameter type: Request type
    /// - Returns: Decodable
    @available(iOS 14.0, *)
    func decodable<T>(for type: F.RequestType) async throws -> URLResponseContainer<T> where T: Decodable {
        try await performTask(for: type) {
            RequestDataTask(session: urlSession)
                .with(validator: adapter)
                .with(decoder: decoder, type: T.self)
        }
    }
    
    /// Returns Data
    /// - Parameter type: Request type
    /// - Returns: Data
    /// performs validation of the response
    @available(iOS 14.0, *)
    func data(for type: F.RequestType) async throws -> URLResponseContainer<Data> {
        try await performTask(for: type) {
            RequestDataTask(session: urlSession)
                .with(validator: adapter)
        }
    }
    

    /// Download data
    /// - Parameters:
    ///   - type: Request type
    ///   - destination: Destination URL
    /// - Returns: Destination URL
    @available(iOS 14.0, *)
    func download(for type: F.RequestType, destination: URL) async throws -> URLResponseContainer<URL> {
       try await performTask(for: type) {
           DownloadDataTaskBase(session: urlSession,
                                destinationURL: destination,
                                mover: fileMover)
       }
    }

    private func performTask<Output, Task>(
        for type: F.RequestType,
        taskBuilder: () -> Task
    ) async throws -> URLResponseContainer<Output> where Task: URLRequestTaskAsync, Task.Body == Output {
        let request = try factory.request(for: type)
        let task = taskBuilder().requestTask
        return try await task.perform(using: request)
    }
}
