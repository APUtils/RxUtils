//
//  RxSwift+Operators+ObservableType.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 7/15/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

public extension RxUtilsError {
    static let noElements: RxUtilsError = .init(code: 1, message: "Subscription was completed without emmiting any elements.")
}

public extension ObservableType {
    
    /// Same as `asSingle()` but completes right after gets the first element.
    /// Ordinary `asSingle()` waits for the completion event.
    func asSafeSingle() -> Single<Element> {
        return self
            .take(1)
            .asSingle()
    }
    
    /// Prevent error emission if observable chain had element.
    func catchErrorIfHadElement() -> Observable<Element> {
        let lock = NSRecursiveLock()
        var element: Element?
        
        return self
            .doOnNext {
                lock.lock(); defer { lock.unlock() }
                
                element = $0
            }
            .catchError {
                lock.lock(); defer { lock.unlock() }
                
                if element != nil {
                    return .empty()
                } else {
                    return .error($0)
                }
            }
    }
    
    /// Throws `RxUtilsError.noElements` if sequence completed without emitting any elements.
    func errorIfNoElements() -> Observable<Element> {
        var gotElement = false
        
        return self
            .doOnNext { _ in
                gotElement = true
            }
            .doOnCompleted {
                if !gotElement {
                    throw RxUtilsError.noElements
                }
            }
    }
    
    /// Projects each element of an observable sequence into Void
    func mapToVoid() -> Observable<Void> {
        return map { _ in () }
    }
    
    /// Creates sequence that can not be canceled
    func preventCancellation() -> Observable<Element> {
        return .create { observer in
            _ = self.subscribe(observer)
            return Disposables.create()
        }
    }
    
    /// Wraps element into optional
    func wrapIntoOptional() -> Observable<Element?> {
        return self.map { $0 }
    }
}

public extension ObservableType where Element: Collection {
    
    /**
     Projects each element of an observable collection into a new form.
     
     - parameter transform: A transform function to apply to each element of the source collection.
     - returns: An observable collection whose elements are the result of invoking the transform function on each element of source.
     */
    
    /**
     Filters each element of an observable collection based on a predicate.
     
     - seealso: [filter operator on reactivex.io](http://reactivex.io/documentation/operators/filter.html)
     
     - parameter predicate: A function to test each element of the source collection.
     - returns: An observable collection that contains elements from the input an original collection that satisfy the condition.
     */
    func filterMany(_ predicate: @escaping (Element.Element) throws -> Bool) -> Observable<[Element.Element]> {
        map { try $0.filter(predicate) }
    }
}

// ******************************* MARK: - Filter with latest

public extension ObservableType {
    
    /// Apply filter to sequence using second sequence.
    /// - parameter second: Sequence to use for comparison.
    /// - parameter comparer: Equality comparer for computed key values.
    /// - returns: Filtered sequence.
    func filterWithLatestFrom<T: ObservableConvertibleType>(_ second: T, _ comparer: @escaping (Element, T.Element) -> Bool) -> Observable<Element> {
        return withLatestFrom(second) { ($0, $1) }
            .filter { comparer($0.0, $0.1) }
            .map { $0.0 }
    }
}

public extension ObservableType where Element: Equatable {
    
    /// Filters out element if it equals to the latest from provided sequence.
    /// - parameter second: Sequence to use for comparison.
    /// - returns: Filtered sequence.
    func filterEqualWithLatestFrom(_ second: Observable<Element>) -> Observable<Element> {
        return withLatestFrom(second) { ($0, $1) }
            .filter { $0 != $1 }
            .map { $0.0 }
    }
}
