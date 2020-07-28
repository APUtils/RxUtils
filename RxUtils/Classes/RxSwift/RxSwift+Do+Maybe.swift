//
//  RxSwift+Do+Maybe.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 3/13/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

public extension PrimitiveSequence where Trait == MaybeTrait {
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onSubscribe: Action to invoke before subscribing to source observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnSubscribe(_ onSubscribe: @escaping () -> Void) -> Maybe<Element> {
        return self.do(onSubscribe: onSubscribe)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onSubscribed: Action to invoke after subscribing to source observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnSubscribed(_ onSubscribed: @escaping () -> Void) -> Maybe<Element> {
        return self.do(onSubscribed: onSubscribed)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onNext: Action to invoke for each element in the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnNext(_ onNext: @escaping (Element) throws -> Void) -> Maybe<Element> {
        return self.do(onNext: onNext)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onError: Action to invoke upon errored termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnError(_ onError: @escaping (Error) throws -> Void) -> Maybe<Element> {
        return self.do(onError: onError)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onDispose: Action to invoke after subscription to source observable has been disposed for any reason. It can be either because sequence terminates for some reason or observer subscription being disposed.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnDispose(_ onDispose: @escaping () -> Void) -> Maybe<Element> {
        return self.do(onDispose: onDispose)
    }
}
