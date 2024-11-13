//
//  RxTimeInterval+Extension.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 14.11.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift
import RoutableLogger

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
        if !isNormal {
            RoutableLogger.logErrorOnce("Trying to cast non-normal TimeInterval to RxTimeInterval is not allowed", data: ["self": self])
            return .never
        }
        
        if self > Double(Int.max) {
            RoutableLogger.logErrorOnce("Trying to cast more than Int.max TimeInterval to RxTimeInterval is not allowed", data: ["self": self])
            return .never
        }
        
        if self < Double(Int.min) {
            RoutableLogger.logErrorOnce("Trying to cast less than Int.min TimeInterval to RxTimeInterval is not allowed", data: ["self": self])
            return .never
        }
        
        var value = self
        if value._isCeil {
            return .seconds(Int(value))
        }
        
        value *= 1000
        if self > Double(Int.max) {
            RoutableLogger.logErrorOnce("value Int.max limit exceeded", data: ["self": self, "value": value])
            return .never
        }
        
        if value._isCeil {
            return .milliseconds(Int(value))
        }
        
        value *= 1000
        if self > Double(Int.max) {
            RoutableLogger.logErrorOnce("value Int.max limit exceeded", data: ["self": self, "value": value])
            return .never
        }
        
        if value._isCeil {
            return .microseconds(Int(value))
        }
        
        value *= 1000
        if self > Double(Int.max) {
            RoutableLogger.logErrorOnce("value Int.max limit exceeded", data: ["self": self, "value": value])
            return .never
        }
        
        return .nanoseconds(Int(value))
    }
    
    /// Returns `true` if `self` is ceil. Returns `false` otherwise.
    private var _isCeil: Bool {
        floor(self) == self
    }
}

// ******************************* MARK: - CustomStringConvertible

extension RxTimeInterval: @retroactive CustomStringConvertible {
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
