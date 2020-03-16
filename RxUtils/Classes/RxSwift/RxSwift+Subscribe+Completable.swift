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
     Subscribes an error handler for this sequence.
     - parameter onCompleted: Action to invoke upon graceful termination of the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func subscribeOnCompleted(_ onCompleted: @escaping () -> Void) -> Disposable {
        return subscribe(onCompleted: onCompleted)
    }
}
