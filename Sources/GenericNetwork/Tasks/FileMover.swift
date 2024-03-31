import Foundation

final class FileMoverBase: FileMover {
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func move(from src: URL, to dst: URL) throws {
        if fileManager.fileExists(atPath: dst.path) {
            try fileManager.removeItem(at: dst)
        }
        try fileManager.moveItem(at: src, to: dst)
    }
}

/// Filemanager implementation of moving file
public protocol FileMover {
    /// Move file from src path to dst
    /// - Parameters:
    ///   - src: URL
    ///   - dst: URL
    func move(from src: URL, to dst: URL) throws
}
