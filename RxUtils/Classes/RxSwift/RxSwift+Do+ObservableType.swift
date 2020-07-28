//
//  RxSwift+Do+ObservableType.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 4/11/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public extension ObservableType {
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onSubscribe: Action to invoke before subscribing to source observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnSubscribe(_ onSubscribe: @escaping () -> Void) -> Observable<Element> {
        return self.do(onSubscribe: onSubscribe)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onSubscribed: Action to invoke after subscribing to source observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnSubscribed(_ onSubscribed: @escaping () -> Void) -> Observable<Element> {
        return self.do(onSubscribed: onSubscribed)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onNext: Action to invoke for each element in the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnNext(_ onNext: @escaping (Element) throws -> Void) -> Observable<Element> {
        return self.do(onNext: onNext)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter afterNext: Action to invoke for each element after the observable has passed an onNext event along to its downstream.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doAfterNext(_ afterNext: @escaping (Element) -> Void) -> Observable<Element> {
        return self.do(afterNext: afterNext)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onError: Action to invoke upon errored termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnError(_ onError: @escaping (Error) throws -> Void) -> Observable<Element> {
        return self.do(onError: onError)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter afterError: Action to invoke after errored termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doAfterError(_ afterError: @escaping (Error) throws -> Void) -> Observable<Element> {
        return self.do(afterError: afterError)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onEmpty: Action to invoke upon graceful termination of the observable sequence if sequence had no elements.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnEmpty(_ onEmpty: @escaping () throws -> Swift.Void) -> Observable<Element> {
        var hadElements = false
        return self.do(onNext: { _ in hadElements = true },
                       onCompleted: { hadElements ? () : try onEmpty() })
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onCompleted: Action to invoke upon graceful termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnCompleted(_ onCompleted: @escaping () throws -> Swift.Void) -> Observable<Element> {
        return self.do(onCompleted: onCompleted)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter afterCompleted: Action to invoke after graceful termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doAfterCompleted(_ afterCompleted: @escaping () -> Swift.Void) -> Observable<Element> {
        return self.do(afterCompleted: afterCompleted)
    }
    
    /**
     Invokes an action for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter onDispose: Action to invoke after subscription to source observable has been disposed for any reason. It can be either because sequence terminates for some reason or observer subscription being disposed.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnDispose(_ onDispose: @escaping () -> Void) -> Observable<Element> {
        return self.do(onDispose: onDispose)
    }
}
