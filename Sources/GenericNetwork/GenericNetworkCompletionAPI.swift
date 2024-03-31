import Foundation

public extension GenericNetwork {
    /// Get decodable object
    /// - Parameters:
    ///   - type: RequestType
    ///   - completion: NetworkResultCompletion<Decodable>
    func data<T>(for type: F.RequestType, completion: @escaping NetworkResultCompletion<T>) where T: Decodable {
        performResultTask(for: type,
                          taskBuilder: {
                                RequestDataTask(session: urlSession)
                                    .with(validator: adapter)
                                    .with(decoder: decoder, type: T.self)
                         },
                          completion: completion)
    }

    /// Dowload data
    /// - Parameters:
    ///   - type: RequestType
    ///   - destination: Destination URL
    ///   - completion: NetworkResultCompletion<URL> with destination URL
    func download(for type: F.RequestType,
                  destination: URL,
                  completion: @escaping NetworkResultCompletion<URL>) {
        let baseTask = DownloadDataTaskBase(session: urlSession,
                                            destinationURL: destination,
                                            mover: fileMover).with(validator: adapter)
        performResultTask(for: type,
                          taskBuilder: { baseTask },
                          completion: completion)
    }

    private func performResultTask<Output, Task>
    (
        for type: F.RequestType,
        taskBuilder: () -> Task,
        completion: @escaping NetworkResultCompletion<Output>
    ) where Task: URLRequestTaskAsync, Task.Body == Output {
        do {
            let request = try factory.request(for: type)
            let task = taskBuilder().requestTask
            task.perform(using: request) { result in
                result.sink(completion)
            }
        } catch {
            completion(.failure(error))
        }
    }
}
