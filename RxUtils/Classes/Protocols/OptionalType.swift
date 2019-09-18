//
//  OptionalType.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 9/3/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    /// Cast `Optional<Wrapped>` to `Wrapped?`
    public var value: Wrapped? {
        return self
    }
}
