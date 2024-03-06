import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@testable import GenericNetwork

final class FileMoverMock: FileMover {
    private(set) var sources: [URL] = []
    private(set) var destinations: [URL] = []
    var expectedError: Error?
    func move(from src: URL, to dst: URL) throws {
        sources.append(src)
        destinations.append(dst)
        if let expectedError { throw expectedError }
    }
    
}
