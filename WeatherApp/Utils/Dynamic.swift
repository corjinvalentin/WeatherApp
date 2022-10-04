//
//  Dynamic.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/28/22.
//

import Foundation

/// Function to be used to unbind from the dynamic
public typealias Unbind = () -> Void

/// Dynamic binding
public class Dynamic<T> {
    public typealias Listener = (T) -> Void

    // Indicates whether listeners should be notified on the main thread.
    private let notifyOnMain: Bool

    /// The list of the listeners
    public var listeners: [(id: UUID, listener: Listener)] = []

    /// The value to be binded
    public var value: T {
        didSet {
            if notifyOnMain {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.listeners.forEach({ $0.listener(self.value) })
                }
            } else {
                listeners.forEach({ $0.listener(value) })
            }
        }
    }

    /// Binds the listener to the value and returns an unbind function to be used to unbind from the dynamic
    ///
    /// - Parameter listener: The listener to bind
    /// - Returns: Unbind function
    @discardableResult
    public func bind(skipCurrent: Bool = false, _ listener: @escaping Listener) -> Unbind {
        let id = UUID()
        self.listeners.append((id, listener))
        if !skipCurrent {
            listener(value)
        }
        return { [weak self] in
            self?.listeners.removeAll { $0.id == id }
        }
    }

    /// Creates the dynamic binding class with the passed type
    ///
    /// - Parameters
    ///   - v: The type to be dynamically binded
    ///   - notifyOnMain: Whether listeners should be notified on the main thread
    public init(_ v: T, notifyOnMain: Bool = false) {
        value = v
        self.notifyOnMain = notifyOnMain
    }
}
