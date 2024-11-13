//
//  RxSwift+FlatMapThrottle.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 22.09.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift
import RoutableLogger

public extension ObservableConvertibleType {
    
    /// Throttles coming events until operation is executed and transforms resulted sequence to `Completable`
    /// Schedules the next operation if there is buffered element.
    /// - note: Buffer size is 1.
    /// - note: Schedules all executions on `scheduler`.
    /// - warning: Execution and processing shouldn't happen on the same queue or it won't work.
    func flatMapThrottleCompletable(
        scheduler: DispatchQueueScheduler,
        selector: @escaping (Self.Element) throws -> Completable
    ) -> Completable {
        
        flatMapThrottle(scheduler: scheduler, selector: { (element) -> Single<Void> in
            try selector(element).andThenDeferred { Single.just(()) }
        })
        .ignoreElements()
        .asCompletable()
    }
    
    /// Throttles coming events until operation is executed.
    /// Schedules the next operation if there is buffered element.
    /// - note: Buffer size is 1.
    /// - note: Schedules all executions on `scheduler`.
    /// - warning: Execution and processing shouldn't happen on the same queue or it won't work.
    func flatMapThrottle<T>(
        scheduler: DispatchQueueScheduler,
        selector: @escaping (Self.Element) throws -> Single<T>
    ) -> Observable<T> {
        
        var _throttledElement: Element? = nil
        var _executing: Bool = false
        let _recursiveLock = NSRecursiveLock()
        let _backgroundQueueKey = DispatchSpecificKey<Void>()
        var _subscribeOnTheSameQueue = false
        
        scheduler.configuration.queue.setSpecific(key: _backgroundQueueKey, value: ())
        
        func executeNext(element: T) -> Observable<T> {
            _recursiveLock.lock(); defer { _recursiveLock.unlock() }
            
            if let throttledElement = _throttledElement {
                _throttledElement = nil
                return Observable.just(throttledElement)
                    .observe(on: scheduler)
                    .flatMap { try selector($0) }
                    .flatMap { executeNext(element: $0) }
                    .startWith(element)
                
            } else {
                _executing = false
                return .just(element)
            }
        }
        
        return asObservable()
            .flatMap { element -> Observable<T> in
                _recursiveLock.lock(); defer { _recursiveLock.unlock() }
                
                if _executing {
                    _throttledElement = element
                    return .empty()
                    
                } else {
                    _executing = true
                    return Observable.just(element)
                        .doOnNext { _ in
                            if DispatchQueue.getSpecific(key: _backgroundQueueKey) != nil {
                                _recursiveLock.lock(); defer { _recursiveLock.unlock() }
                                _subscribeOnTheSameQueue = true
                            }
                        }
                        .observe(on: scheduler)
                        .flatMap { try selector($0) }
                        .doOnNext { _ in
                            _recursiveLock.lock(); defer { _recursiveLock.unlock() }
                            if _subscribeOnTheSameQueue {
                                RoutableLogger.logError("Events and execution should not happen on the same queue or `flatMapThrottle` won't work.")
                            }
                        }
                        .flatMap { executeNext(element: $0) }
                }
            }
    }
}
