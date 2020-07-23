//
//  RxCocoa+Do+Driver.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 7/23/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     - parameter onSubscribed: Action to invoke after subscribing to source observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnSubscribe(_ onSubscribe: @escaping () -> Void) -> Driver<Element> {
        return self.do(onSubscribe: onSubscribe)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     - parameter onSubscribed: Action to invoke after subscribing to source observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnSubscribed(_ onSubscribed: @escaping () -> Void) -> Driver<Element> {
        return self.do(onSubscribed: onSubscribed)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     - parameter onNext: Action to invoke for each element in the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnNext(_ onNext: @escaping (Element) -> Void) -> Driver<Element> {
        return self.do(onNext: onNext)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     - parameter onNext: Action to invoke for each element in the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnNext(_ onNext: @escaping () -> Void) -> Driver<Element> {
        return self.do(onNext: { _ in onNext() })
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     - parameter afterNext: Action to invoke for each element after the observable has passed an onNext event along to its downstream.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doAfterNext(_ afterNext: @escaping (Element) -> Void) -> Driver<Element> {
        return self.do(afterNext: afterNext)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     - parameter onEmpty: Action to invoke upon graceful termination of the observable sequence if sequence had no elements.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnEmpty(_ onEmpty: @escaping () -> Swift.Void) -> Driver<Element> {
        var hadElements = false
        return self.do(onNext: { _ in hadElements = true },
                       onCompleted: { hadElements ? () : onEmpty() })
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     - parameter onCompleted: Action to invoke upon graceful termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnCompleted(_ onCompleted: @escaping () -> Swift.Void) -> Driver<Element> {
        return self.do(onCompleted: onCompleted)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     - parameter afterCompleted: Action to invoke after graceful termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doAfterCompleted(_ afterCompleted: @escaping () -> Swift.Void) -> Driver<Element> {
        return self.do(afterCompleted: afterCompleted)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     - parameter onDispose: Action to invoke after subscription to source observable has been disposed for any reason. It can be either because sequence terminates for some reason or observer subscription being disposed.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnDispose(_ onDispose: @escaping () -> Void) -> Driver<Element> {
        return self.do(onDispose: onDispose)
    }
}
