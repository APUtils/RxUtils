//
//  RxCocoa+Signal.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 7/16/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

// ******************************* MARK: - Emit

public extension SharedSequenceConvertibleType where SharingStrategy == SignalSharingStrategy {
    
    /**
     Subscribes an element handler to an observable sequence.
     - parameter onNext: Action to invoke for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func emitOnNext(_ onNext: @escaping (Element) -> Void) -> Disposable {
        return emit(onNext: onNext)
    }
    
    /**
     Subscribes a completion handler to an observable sequence.
     - parameter onCompleted: Action to invoke upon graceful termination of the observable sequence.
     gracefully completed, errored, or if the generation is canceled by disposing subscription)
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func emitOnCompleted(_ onCompleted: @escaping () -> Void) -> Disposable {
        return emit(onCompleted: onCompleted)
    }
    
    /**
     Subscribes a disposed handler to an observable sequence.
     - parameter onDisposed: Action to invoke upon any type of termination of sequence (if the sequence has
     gracefully completed, errored, or if the generation is canceled by disposing subscription)
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func emitOnDisposed(_ onDisposed: @escaping () -> Void) -> Disposable {
        return emit(onDisposed: onDisposed)
    }
}
