//
//  RxCocoa+Drive.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 5/17/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

// ******************************* MARK: - Driver

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    
    /**
     Subscribes an element handler to an observable sequence.
     This method can be only called from `MainThread`.
     
     - parameter onNext: Action to invoke for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func driveOnNext(_ onNext: @escaping (E) -> Void) -> Disposable {
        return drive(onNext: onNext)
    }
    
    /**
     Subscribes a completion handler to an observable sequence.
     This method can be only called from `MainThread`.
     
     - parameter onCompleted: Action to invoke upon graceful termination of the observable sequence.
     gracefully completed, errored, or if the generation is canceled by disposing subscription)
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func driveOnCompleted(_ onCompleted: @escaping () -> Void) -> Disposable {
        return drive(onCompleted: onCompleted)
    }
    
    /**
     Subscribes a disposed handler to an observable sequence.
     This method can be only called from `MainThread`.
     
     - parameter onDisposed: Action to invoke upon any type of termination of sequence (if the sequence has
     gracefully completed, errored, or if the generation is canceled by disposing subscription)
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func driveOnDisposed(_ onDisposed: @escaping () -> Void) -> Disposable {
        return drive(onDisposed: onDisposed)
    }
}
