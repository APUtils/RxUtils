//
//  RxSwift+Subscribe+Single.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 12/16/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

public extension PrimitiveSequence where Trait == SingleTrait {
    
    /**
     Subscribes a success handler for this sequence.
     - parameter onSuccess: Action to invoke for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func subscribeOnSuccess(_ onSuccess: @escaping (Element) -> Void) -> Disposable {
        return subscribe(onSuccess: onSuccess)
    }
    
    /**
     Subscribes an error handler for this sequence.
     - parameter onError: Action to invoke upon errored termination of the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func subscribeOnFailure(_ onFailure: @escaping (Error) -> Void) -> Disposable {
        return subscribe(onFailure: onFailure)
    }
}
