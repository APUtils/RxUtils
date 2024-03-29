//
//  RxCocoa+CompareWithPrevious+Driver.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 7/15/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

// ******************************* MARK: - Any Element

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    /// Compares with previous element using `comparator` closure and wraps sequence into CompareResult.
    func compareWithPrevious(_ comparator: @escaping (Element, Element) -> Bool) -> Driver<CompareResult<Element>> {
        let _recursiveLock = NSRecursiveLock()
        var _previous: Element?
        return map { new in
            _recursiveLock.lock()
            defer {
                _previous = new
                _recursiveLock.unlock()
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

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element: Equatable {
    /// Compares with previous element and wraps sequence into CompareResult.
    func compareWithPrevious() -> Driver<CompareResult<Element>> {
        let _recursiveLock = NSRecursiveLock()
        var _previous: Element?
        return map { new in
            _recursiveLock.lock()
            defer {
                _previous = new
                _recursiveLock.unlock()
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
