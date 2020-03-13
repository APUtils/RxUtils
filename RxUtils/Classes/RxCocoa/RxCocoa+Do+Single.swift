//
//  RxCocoa+Do+Single.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 5/31/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public extension PrimitiveSequence where Trait == SingleTrait {
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onSubscribe: Action to invoke before subscribing to source observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnSubscribe(_ onSubscribe: @escaping () -> Void) -> Single<Element> {
        return self.do(onSubscribe: onSubscribe)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onSubscribed: Action to invoke after subscribing to source observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnSubscribed(_ onSubscribed: @escaping () -> Void) -> Single<Element> {
        return self.do(onSubscribed: onSubscribed)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onSuccess: Action to invoke for each element in the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnSuccess(_ onSuccess: @escaping (Element) throws -> Void) -> Single<Element> {
        return self.do(onSuccess: onSuccess)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onSuccess: Action to invoke for each element in the observable sequence. Takes no arguments so can be used in a places where we do not need it.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnSuccess(_ onSuccess: @escaping () throws -> Void) -> Single<Element> {
        return self.do(onSuccess: { _ in try onSuccess() })
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onError: Action to invoke upon errored termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnError(_ onError: @escaping (Error) throws -> Void) -> Single<Element> {
        return self.do(onError: onError)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onDispose: Action to invoke after subscription to source observable has been disposed for any reason. It can be either because sequence terminates for some reason or observer subscription being disposed.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnDispose(_ onDispose: @escaping () -> Void) -> Single<Element> {
        return self.do(onDispose: onDispose)
    }
}
