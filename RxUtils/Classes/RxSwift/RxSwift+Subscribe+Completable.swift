//
//  RxSwift+Subscribe+Completable.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 3/13/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

public extension PrimitiveSequence where Trait == CompletableTrait, Element == Never {
    
    /**
     Subscribes an error handler for this sequence.
     - parameter onError: Action to invoke upon errored termination of the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func subscribeOnError(_ onError: @escaping (Error) -> Void) -> Disposable {
        return subscribe(onError: onError)
    }
    
    /**
     Subscribes a completion handler for this sequence.
     - parameter onCompleted: Action to invoke upon graceful termination of the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func subscribeOnCompleted(_ onCompleted: @escaping () -> Void) -> Disposable {
        return subscribe(onCompleted: onCompleted)
    }
    
    /**
     Subscribes a disposed handler for this sequence.
     - parameter onDisposed: Action to invoke upon any type of termination of sequence (if the sequence has
     gracefully completed, errored, or if the generation is canceled by disposing subscription).
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func subscribeOnDisposed(_ onDisposed: @escaping () -> Void) -> Disposable {
        return subscribe(onDisposed: onDisposed)
    }
}
