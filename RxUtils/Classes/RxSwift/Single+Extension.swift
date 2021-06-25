//
//  Single+Extension.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 3/21/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt

public extension PrimitiveSequence where Trait == SingleTrait {
    
    /**
     Projects success element of a single trait sequence to an observable sequence.
     
     - seealso: [flatMap operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
     
     - parameter selector: A transform function to apply to an element.
     - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on success element.
     */
    func flatMapObservable<Result>(_ selector: @escaping (Element) throws -> Observable<Result>) -> Observable<Result> {
        asObservable()
            .flatMap(selector)
    }
    
    /**
     Projects success element of a single trait sequence to a completable sequence.
     
     - seealso: [flatMap operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
     
     - parameter selector: A transform function to apply to an element.
     - returns: A completable sequence.
     */
    func flatMapCompletable(_ selector: @escaping (Element) throws -> Completable) -> Completable {
        asObservable()
            .flatMap(selector)
            .asCompletable()
    }
    
    /**
     Repeats the source single sequence using given behavior in case of an error or until it successfully terminated
     - parameter behavior: Behavior that will be used in case of an error
     - parameter scheduler: Scheduler that will be used for delaying subscription after error
     - parameter shouldRetry: Custom optional closure for checking error (if returns true, repeat will be performed)
     - returns: Single sequence that will be automatically repeat if error occurred
     */
    func retry(_ behavior: RepeatBehavior,
               scheduler: SchedulerType = MainScheduler.instance,
               shouldRetry: RetryPredicate? = nil) -> Single<Element> {
        
        asObservable()
            .retry(behavior, scheduler: scheduler, shouldRetry: shouldRetry)
            .asSingle()
    }
}
