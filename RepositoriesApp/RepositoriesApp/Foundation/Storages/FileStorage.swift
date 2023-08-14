import Foundation

@propertyWrapper
public struct FileStorage<T: Codable & Equatable> {
    public var wrappedValue: T? {
        didSet {
            guard oldValue != wrappedValue else {
                return
            }

            updateWrappedValue()
        }
    }

    private let directory: DiskDirectory
    private let path: String

    private let disk = Disk()

    public init(directory: DiskDirectory = .caches, path: String) {
        self.directory = directory
        self.path = path

        self.wrappedValue = try? disk.retrieve(path, from: directory, as: T.self)
    }

    private func updateWrappedValue() {
        if let wrappedValue {
            try? disk.save(wrappedValue, to: directory, as: path)
        } else {
            try? disk.remove(path, from: directory)
        }
    }
}
