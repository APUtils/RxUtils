//
//  RxTimeInterval+Extension.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 14.11.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import RxSwift

// ******************************* MARK: - TimeInterval

public extension RxTimeInterval {
    /// Returns `self` as `TimeInterval` in seconds.
    var asTimeInterval: TimeInterval {
        switch self {
        case .seconds(let seconds): return seconds.asTimeInterval
        case .milliseconds(let milliseconds): return milliseconds.asTimeInterval / 1000
        case .microseconds(let microseconds): return microseconds.asTimeInterval / 1000000
        case .nanoseconds(let nanoseconds): return nanoseconds.asTimeInterval / 1000000000
        case .never: return TimeInterval.greatestFiniteMagnitude
        @unknown default: return 0
        }
    }
}

private extension Int {
    
    /// Returns `self` as `TimeInterval`
    var asTimeInterval: TimeInterval { .init(self) }
}

public extension TimeInterval {
    /// Transforms `self` into `RxTimeInterval`.
    var asRxTimeInterval: RxTimeInterval {
        .nanoseconds(Int(self * 1000000000.0))
    }
}

// ******************************* MARK: - CustomStringConvertible

extension RxTimeInterval: CustomStringConvertible {
    public var description: String {
        switch self {
        case .seconds(let seconds): return "\(seconds) seconds"
        case .milliseconds(let milliseconds): return "\(milliseconds) milliseconds"
        case .microseconds(let microseconds): return "\(microseconds) microseconds"
        case .nanoseconds(let nanoseconds): return "\(nanoseconds) nanoseconds"
        case .never: return "never"
        @unknown default: return ""
        }
    }
}
