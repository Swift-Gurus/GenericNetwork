import Foundation

public protocol FileMover {
    func move(from src: URL, to dst: URL) throws
}

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
