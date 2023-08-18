// swiftlint:disable orphaned_doc_comment superfluous_disable_command
/// Copyright (c) 2020 Petro Korienev <soxjke@gmail.com>
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

// MARK: - Debounce

@propertyWrapper
public final class Debounce<T> {
    public var wrappedValue: T {
        get { value }
        set { receive(newValue) }
    }

    private var value: T
    private var valueTimestamp = Date()
    private var interval: TimeInterval
    private let queue: DispatchQueue
    private var callback: ((T) -> Void)?
    private var debounceWorkItem = DispatchWorkItem {}

    public init(
        _ value: T,
        interval: TimeInterval,
        on queue: DispatchQueue = .main
    ) {
        self.value = value
        self.interval = interval
        self.queue = queue
    }

    public func receive(_ value: T, shouldDispatchDebounce: Bool = true) {
        self.value = value
        if shouldDispatchDebounce {
            dispatchDebounce()
        }
    }

    public func set(interval: TimeInterval) {
        self.interval = interval
    }

    public func on(debounced: @escaping (T) -> Void) {
        callback = debounced
    }

    public func cancelDebounce() {
        debounceWorkItem.cancel()
    }

    private func dispatchDebounce() {
        valueTimestamp = Date()
        debounceWorkItem.cancel()
        debounceWorkItem = DispatchWorkItem { [weak self] in
            self?.onDebounce()
        }
        queue.asyncAfter(deadline: .now() + interval, execute: debounceWorkItem)
    }

    private func onDebounce() {
        if Date().timeIntervalSince(valueTimestamp) > interval {
            callback?(value)
        }
    }
}

// MARK: - Debounce + String

extension Debounce where T == String {
    public convenience init(_ interval: TimeInterval) {
        self.init("", interval: interval)
    }
}

// MARK: - Debounce + Bool

extension Debounce where T == Bool {
    public convenience init(_ interval: TimeInterval) {
        self.init(false, interval: interval)
    }
}
