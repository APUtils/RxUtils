//
//  RxSwift+CompareWithPrevious+ObservableType.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 7/15/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

// ******************************* MARK: - Enum

/// Comparation result
public enum CompareResult<T> {
    
    /// Initial value
    case initial(value: T)
    
    /// Previous value is the same as current
    case same(previous: T, new: T)
    
    /// New value distinguish from previous
    case new(previous: T, new: T)
    
    /// Is it an initial result?
    public var isInitial: Bool {
        switch self {
        case .initial: return true
        default: return false
        }
    }
    
    /// Is previous value the same as new?
    public var isSame: Bool {
        switch self {
        case .same: return true
        default: return false
        }
    }
    
    /// Is previous value distinguish from new?
    public var isNew: Bool {
        switch self {
        case .new: return true
        default: return false
        }
    }
    
    /// Returns value for initial state and previous for same and new states.
    public var previous: T {
        switch self {
        case .initial(let value): return value
        case .same(let previous, _): return previous
        case .new(let previous, _): return previous
        }
    }
    
    /// Returns value for initial state and new for same and new states.
    public var new: T {
        switch self {
        case .initial(let value): return value
        case .same(_, let new): return new
        case .new(_, let new): return new
        }
    }
}

// ******************************* MARK: - Any Element

public extension ObservableType {
    /// Compares with previous element using `comparator` closure and wraps sequence into CompareResult.
    func compareWithPrevious(_ comparator: @escaping (Element, Element) -> Bool) -> Observable<CompareResult<Element>> {
        let lock = NSRecursiveLock()
        var _previous: Element?
        return map { new in
            lock.lock()
            defer {
                _previous = new
                lock.unlock()
            }
            
            if let previous = _previous {
                if comparator(previous, new) {
                    return .same(previous: previous, new: new)
                } else {
                    return .new(previous: previous, new: new)
                }
            } else {
                return .initial(value: new)
            }
        }
    }
}

// ******************************* MARK: - Equatable Element

public extension ObservableType where Element: Equatable {
    /// Compares with previous element and wraps sequence into CompareResult.
    func compareWithPrevious() -> Observable<CompareResult<Element>> {
        let lock = NSRecursiveLock()
        var _previous: Element?
        return map { new in
            lock.lock()
            defer {
                _previous = new
                lock.unlock()
            }
            
            if let previous = _previous {
                if previous == new {
                    return .same(previous: previous, new: new)
                } else {
                    return .new(previous: previous, new: new)
                }
            } else {
                return .initial(value: new)
            }
        }
    }
}
