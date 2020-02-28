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
