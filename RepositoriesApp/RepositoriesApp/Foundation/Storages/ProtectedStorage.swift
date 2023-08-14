import KeychainAccess

// MARK: - ProtectedStorage

@propertyWrapper
public struct ProtectedStorage {
    public var wrappedValue: String? {
        didSet {
            guard oldValue != wrappedValue else {
                return
            }

            updateWrappedValue()
        }
    }

    private let key: String
    private let keychain: Keychain

    public init(key: String, accessibility: Accessibility = .always) {
        self.key = key
        self.keychain = Keychain(service: "Disk Config").accessibility(accessibility)
        self.wrappedValue = try? keychain.get(key)
    }

    private func updateWrappedValue() {
        if let wrappedValue {
            try? keychain.set(wrappedValue, key: key)
        } else {
            try? keychain.remove(key)
        }
    }
}
