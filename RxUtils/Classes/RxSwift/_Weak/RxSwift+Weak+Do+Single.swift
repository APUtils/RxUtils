//
//  RxSwift+Weak+Do+Single.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 5/30/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

// ******************************* MARK: - doOnSuccess

public extension PrimitiveSequence where Trait == SingleTrait {
    private func weakify<A: AnyObject>(_ obj: A, method: @escaping (A) -> (Element) throws -> Void) -> ((Element) throws -> Void) {
        return { [weak obj] value throws -> Void in
            guard let obj = obj else { return }
            return try method(obj)(value)
        }
    }
    
    /**
     Invokes an action on `weak` for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onSuccess: Action to invoke for each element in the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnSuccess<A: AnyObject>(weak obj: A, _ onSuccess: @escaping (A) -> (Element) throws -> Void) -> Single<Element> {
        return self.do(onSuccess: weakify(obj, method: onSuccess))
    }
    
    /**
     Invokes an action on `weak` for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onSuccess: Action to invoke for each element in the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnSuccess<A: AnyObject>(weak obj: A, _ onSuccess: @escaping (A, Element) throws -> Void) -> Single<Element> {
        return self.do(onSuccess: { [weak obj] element -> Void in
            guard let obj = obj else { return }
            return try onSuccess(obj, element)
        })
    }
}

// ******************************* MARK: - doOnError

public extension PrimitiveSequence where Trait == SingleTrait {
    private func weakify<A: AnyObject>(_ obj: A, method: @escaping (A) -> (Error) throws -> Void) -> ((Error) throws -> Void) {
        return { [weak obj] value throws -> Void in
            guard let obj = obj else { return }
            return try method(obj)(value)
        }
    }
    
    /**
     Invokes an action on `weak` for error in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onError: Action to invoke upon errored termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnError<A: AnyObject>(weak obj: A, _ onError: @escaping (A) -> (Error) throws -> Void) -> Single<Element> {
        return self.do(onError: weakify(obj, method: onError))
    }
    
    /**
     Invokes an action on `weak` for error in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onError: Action to invoke upon errored termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnError<A: AnyObject>(weak obj: A, _ onError: @escaping (A, Error) throws -> Void) -> Single<Element> {
        return self.do(onError: { [weak obj] error -> Void in
            guard let obj = obj else { return }
            return try onError(obj, error)
        })
    }
}
