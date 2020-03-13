//
//  RxCocoa+Do+Completable.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 3/13/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public extension PrimitiveSequence where Trait == CompletableTrait, Element == Never {
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onSubscribe: Action to invoke before subscribing to source observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnSubscribe(_ onSubscribe: @escaping () -> Void) -> Completable {
        return self.do(onSubscribe: onSubscribe)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onSubscribed: Action to invoke after subscribing to source observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnSubscribed(_ onSubscribed: @escaping () -> Void) -> Completable {
        return self.do(onSubscribed: onSubscribed)
    }

    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.

     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)

     - parameter onError: Action to invoke upon errored termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnError(_ onError: @escaping (Error) throws -> Void) -> Completable {
        return self.do(onError: onError)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onCompleted: Action to invoke upon graceful termination of the observable sequence. can be either because sequence terminates for some reason or observer subscription being disposed.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnCompleted(_ onCompleted: @escaping () -> Void) -> Completable {
        return self.do(onCompleted: onCompleted)
    }

    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.

     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)

     - parameter onDispose: Action to invoke after subscription to source observable has been disposed for any reason. It can be either because sequence terminates for some reason or observer subscription being disposed.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnDispose(_ onDispose: @escaping () -> Void) -> Completable {
        return self.do(onDispose: onDispose)
    }
}
