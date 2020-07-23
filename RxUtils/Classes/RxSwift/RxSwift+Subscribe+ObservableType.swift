//
//  RxSwift+Subscribe+ObservableType.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 4/11/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

// ******************************* MARK: - ObservableType

public extension ObservableType {
    
    /**
     Subscribes an element handler to an observable sequence.
     - parameter onNext: Function to invoke on `weak` for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func subscribeOnNext(_ onNext: @escaping (Element) -> Void) -> Disposable {
        return subscribe(onNext: onNext)
    }
    
    /**
     Subscribes an error handler to an observable sequence.
     - parameter onError: Function to invoke on `weak` upon errored termination of the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func subscribeOnError(_ onError: @escaping (Error) -> Void) -> Disposable {
        return subscribe(onError: onError)
    }
    
    /**
     Subscribes a completion handler to an observable sequence.
     - parameter onCompleted: Function to invoke on `weak` upon graceful termination of the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func subscribeOnCompleted(_ onCompleted: @escaping () -> Void) -> Disposable {
        return subscribe(onCompleted: onCompleted)
    }
    
    /**
     Subscribes a disposed handler to an observable sequence.
     - parameter onDisposed: Function to invoke on `weak` upon any type of termination of sequence (if the sequence has
     gracefully completed, errored, or if the generation is cancelled by disposing subscription)
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func subscribeOnDisposed(_ onDisposed: @escaping () -> Void) -> Disposable {
        return subscribe(onDisposed: onDisposed)
    }
}
