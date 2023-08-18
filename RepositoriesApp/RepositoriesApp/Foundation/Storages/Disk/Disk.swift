import Foundation

// MARK: - Disk

final class Disk {
    private let fileManager = FileManager.default

    func retrieve<T: Decodable>(
        _ path: String,
        from directory: DiskDirectory,
        as type: T.Type,
        decoder: JSONDecoder
    ) throws -> T {
        if path.hasSuffix("/") {
            throw makeInvalidFileNameForStructsError()
        }
        do {
            let url = try getExistingFileURL(for: path, in: directory)
            let data = try Data(contentsOf: url)
            let value = try decoder.decode(type, from: data)
            return value
        } catch {
            throw error
        }
    }

    func save(
        _ value: some Encodable,
        to directory: DiskDirectory,
        as path: String,
        encoder: JSONEncoder
    ) throws {
        if path.hasSuffix("/") {
            throw makeInvalidFileNameForStructsError()
        }
        do {
            let url = try makeURL(for: path, in: directory)
            let data = try encoder.encode(value)
            try makeSubfoldersBeforeCreatingFile(at: url)
            try data.write(to: url, options: .atomic)
        } catch {
            throw error
        }
    }

    func remove(
        _ path: String,
        from directory: DiskDirectory
    ) throws {
        do {
            let url = try getExistingFileURL(for: path, in: directory)
            try fileManager.removeItem(at: url)
        } catch {
            throw error
        }
    }
}

// MARK: - Convenience Methods

extension Disk {
    func retrieve<T: Decodable>(
        _ path: String,
        from directory: DiskDirectory,
        as type: T.Type
    ) throws -> T {
        try retrieve(
            path,
            from: directory,
            as: type,
            decoder: JSONDecoder.default
        )
    }

    func save(
        _ value: some Encodable,
        to directory: DiskDirectory,
        as path: String
    ) throws {
        try save(
            value,
            to: directory,
            as: path,
            encoder: JSONEncoder()
        )
    }
}

// MARK: - URL

extension Disk {
    private func getExistingFileURL(for path: String?, in directory: DiskDirectory) throws -> URL {
        do {
            let url = try makeURL(for: path, in: directory)
            if fileManager.fileExists(atPath: url.path) {
                return url
            }

            throw makeError(
                .noFileFound,
                description: "Could not find an existing file or folder at \(url.path).",
                failureReason: "There is no existing file or folder at \(url.path)",
                recoverySuggestion: "Check if a file or folder exists before trying to commit an operation on it."
            )
        } catch {
            throw error
        }
    }

    private func makeSubfoldersBeforeCreatingFile(at url: URL) throws {
        do {
            let subfolderURL = url.deletingLastPathComponent()
            var subfolderExists = false
            var isDirectory: ObjCBool = false
            if fileManager.fileExists(atPath: subfolderURL.path, isDirectory: &isDirectory) {
                if isDirectory.boolValue {
                    subfolderExists = true
                }
            }
            if !subfolderExists {
                try fileManager.createDirectory(at: subfolderURL, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            throw error
        }
    }

    private func makeURL(for path: String?, in directory: DiskDirectory) throws -> URL {
        let filePrefix = "file://"
        var validPath: String?
        if let path {
            do {
                validPath = try getValidFilePath(from: path)
            } catch {
                throw error
            }
        }

        let searchPathDirectory = makeSearchDirectory(from: directory)

        if var url = fileManager.urls(for: searchPathDirectory, in: .userDomainMask).first {
            if let validPath {
                url = url.appendingPathComponent(validPath, isDirectory: false)
            }

            if url.absoluteString.lowercased().prefix(filePrefix.count) != filePrefix {
                let fixedURLString = filePrefix + url.absoluteString
                url = URL(string: fixedURLString)!
            }
            return url
        } else {
            throw makeError(
                .couldNotAccessUserDomainMask,
                description: "Could not create URL for \(directory.pathDescription)/\(validPath ?? "")",
                failureReason: "Could not get access to the file system's user domain mask.",
                recoverySuggestion: "Use a different directory."
            )
        }
    }

    private func getValidFilePath(from originalString: String) throws -> String {
        var invalidCharacters = CharacterSet(charactersIn: ":")
        invalidCharacters.formUnion(.newlines)
        invalidCharacters.formUnion(.illegalCharacters)
        invalidCharacters.formUnion(.controlCharacters)
        let pathWithoutIllegalCharacters = originalString.components(separatedBy: invalidCharacters).joined()
        let validFileName = removeSlashesAtBeginning(of: pathWithoutIllegalCharacters)

        guard !validFileName.isEmpty, validFileName != "." else {
            throw makeError(
                .invalidFileName,
                description: "\(originalString) is an invalid file name.",
                failureReason: "Cannot write/read a file with the name \(originalString) on disk.",
                recoverySuggestion: "Use another file name with alphanumeric characters."
            )
        }

        return validFileName
    }

    private func removeSlashesAtBeginning(of string: String) -> String {
        var string = string
        if string.prefix(1) == "/" {
            string.remove(at: string.startIndex)
        }
        if string.prefix(1) == "/" {
            string = removeSlashesAtBeginning(of: string)
        }
        return string
    }

    private func makeSearchDirectory(from directory: DiskDirectory) -> FileManager.SearchPathDirectory {
        switch directory {
        case .documents:
            return .documentDirectory
        case .caches:
            return .cachesDirectory
        }
    }
}

// MARK: - Error

extension Disk {
    private enum ErrorCode: Int {
        case noFileFound = 0
        case serialization = 1
        case deserialization = 2
        case invalidFileName = 3
        case couldNotAccessTemporaryDirectory = 4
        case couldNotAccessUserDomainMask = 5
        case couldNotAccessSharedContainer = 6
    }

    private func makeError(
        _ errorCode: ErrorCode,
        description: String?,
        failureReason: String?,
        recoverySuggestion: String?
    ) -> Error {
        let errorInfo: [String: Any] = [
            NSLocalizedDescriptionKey: description ?? "",
            NSLocalizedRecoverySuggestionErrorKey: recoverySuggestion ?? "",
            NSLocalizedFailureReasonErrorKey: failureReason ?? ""
        ]
        return NSError(domain: "DiskErrorDomain", code: errorCode.rawValue, userInfo: errorInfo) as Error
    }

    private func makeInvalidFileNameForStructsError() -> Error {
        // swiftlint:disable line_length
        makeError(
            .invalidFileName,
            description: "Cannot save/retrieve the Codable struct without a valid file name. Codable structs are not saved as multiple files in a folder, but rather as one JSON file. If you already successfully saved Codable struct(s) to your folder name, try retrieving it as a file named 'Folder' instead of as a folder 'Folder/'",
            failureReason: "Disk does not save structs or arrays of structs as multiple files to a folder like it does UIImages or Data.",
            recoverySuggestion: "Save your struct or array of structs as one file that encapsulates all the data (i.e. \"multiple-messages.json\")"
        )
        // swiftlint:enable line_length
    }
}

// MARK: - DiskDirectory + PathDescription

extension DiskDirectory {
    fileprivate var pathDescription: String {
        switch self {
        case .documents:
            return "<Application_Home>/Documents"
        case .caches:
            return "<Application_Home>/Library/Caches"
        }
    }
}
