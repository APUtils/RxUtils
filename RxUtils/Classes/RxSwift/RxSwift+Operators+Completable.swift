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
    func andThenDeffered<Element>(_ deffered: @escaping () -> Single<Element>) -> Single<Element> {
        andThen(
            Single<Element>.deferred(deffered)
        )
    }
    
    /// Concatenates the second observable sequence to `self` upon successful termination of `self` and deffers its computation.
    func andThenDeffered<Element>(_ deffered: @escaping () -> Observable<Element>) -> Observable<Element> {
        andThen(
            Observable<Element>.deferred {
                deffered().asObservable()
            }
        )
    }
    
    /// Concatenates the second observable sequence to `self` upon successful termination of `self` and deffers its computation.
    func andThenDeffered(_ deffered: @escaping () -> Completable) -> Completable {
        andThen(
            Completable.deferred(deffered)
        )
    }
    
    /// Concatenates the second observable sequence to `self` upon successful termination of `self` and deffers its computation.
    func andThenDeffered<Element>(_ deffered: @escaping () -> Maybe<Element>) -> Maybe<Element> {
        andThen(
            Maybe<Element>.deferred(deffered)
        )
    }
}
