//
//  RxSwift+Operators+Completable.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 14.11.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt

public extension Completable {
    
    /// Creates sequence that can not be disposed.
    /// - parameter disposeBag: Optional dispose bag that will be used to perform long-lasted subscription.
    /// - note: Please keep in mind that subscription is not disposed if sequence never ends.
    /// This may lead to infinite memory grow.
    func preventDisposal(disposeBag: DisposeBag? = nil) -> Completable {
        return Completable.create { observer in
            let recursiveLock = NSRecursiveLock()
            var observer: CompletableObserver? = observer
            let disposable = self.subscribe { event in
                recursiveLock.lock(); defer { recursiveLock.unlock() }
                observer?(event)
            }
            
            if let disposeBag = disposeBag {
                disposeBag.insert(disposable)
            }
            
            return Disposables.create {
                recursiveLock.lock(); defer { recursiveLock.unlock() }
                observer = nil
            }
        }
    }
    
    /**
     Repeats the source completable sequence using given behavior in case of an error or until it successfully terminated
     - parameter behavior: Behavior that will be used in case of an error
     - parameter scheduler: Scheduler that will be used for delaying subscription after error
     - parameter shouldRetry: Custom optional closure for checking error (if returns true, repeat will be performed)
     - returns: Completable sequence that will be automatically repeat if error occurred
     */
    func retry(_ behavior: RepeatBehavior,
               scheduler: SchedulerType = MainScheduler.instance,
               shouldRetry: RetryPredicate? = nil) -> Completable {
        
        asObservable()
            .retry(behavior, scheduler: scheduler, shouldRetry: shouldRetry)
            .asCompletable()
    }
    
    /// Concatenates the second observable sequence to `self` upon successful termination of `self` and deffers its computation.
    func andThenDeferred<Element>(_ deferred: @escaping () -> Single<Element>) -> Single<Element> {
        andThen(
            Single<Element>.deferred(deferred)
        )
    }
    
    /// Concatenates the second observable sequence to `self` upon successful termination of `self` and deffers its computation.
    func andThenDeferred<Element>(_ deferred: @escaping () -> Observable<Element>) -> Observable<Element> {
        andThen(
            Observable<Element>.deferred {
                deferred().asObservable()
            }
        )
    }
    
    /// Concatenates the second observable sequence to `self` upon successful termination of `self` and deffers its computation.
    func andThenDeferred(_ deferred: @escaping () -> Completable) -> Completable {
        andThen(
            Completable.deferred(deferred)
        )
    }
    
    /// Concatenates the second observable sequence to `self` upon successful termination of `self` and deffers its computation.
    func andThenDeferred<Element>(_ deferred: @escaping () -> Maybe<Element>) -> Maybe<Element> {
        andThen(
            Maybe<Element>.deferred(deferred)
        )
    }
}
