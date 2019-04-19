//
//  RxSwift+Weak+Do.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 4/12/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

// ******************************* MARK: - doOnNext

public extension ObservableType {
    private func weakify<A: AnyObject>(_ obj: A, method: @escaping (A) -> (E) throws -> Void) -> ((E) throws -> Void) {
        return { [weak obj] value throws -> Void in
            guard let obj = obj else { return }
            return try method(obj)(value)
        }
    }
    
    /**
     Invokes an action on `weak` for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onNext: Action to invoke on `weak` for each element in the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnNext<A: AnyObject>(weak obj: A, _ onNext: @escaping (A) -> (E) throws -> Void) -> Observable<E> {
        return self.do(onNext: weakify(obj, method: onNext))
    }
    
    /**
     Invokes an action on `weak` for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onNext: Action to invoke on `weak` for each element in the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnNext<A: AnyObject>(weak obj: A, _ onNext: @escaping (A, E) throws -> Void) -> Observable<E> {
        return doOnNext { [weak obj] element -> Void in
            guard let obj = obj else { return }
            return try onNext(obj, element)
        }
    }
    
    /**
     Invokes an action on `weak` for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onNext: Action to invoke on `weak` for each element in the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnNext<A: AnyObject>(weak obj: A, _ onNext: @escaping (A) -> () throws -> Void) -> Observable<E> {
        return doOnNext { [weak obj] _ in
            guard let obj = obj else { return }
            return try onNext(obj)()
        }
    }
}

// ******************************* MARK: - doOnError

extension ObservableType {
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
     - parameter onError: Action to invoke on `weak` upon errored termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnError<A: AnyObject>(weak obj: A, _ onError: @escaping (A) -> (Error) throws -> Void) -> Observable<E> {
        return self.do(onError: weakify(obj, method: onError))
    }
    
    /**
     Invokes an action on `weak` for error in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onError: Action to invoke on `weak` upon errored termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnError<A: AnyObject>(weak obj: A, _ onError: @escaping (A, Error) throws -> Void) -> Observable<E> {
        return doOnError { [weak obj] error -> Void in
            guard let obj = obj else { return }
            return try onError(obj, error)
        }
    }
    
    /**
     Invokes an action on `weak` for error in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onError: Action to invoke on `weak` upon errored termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnError<A: AnyObject>(weak obj: A, _ onError: @escaping (A) -> () throws -> Void) -> Observable<E> {
        return doOnError { [weak obj] _ in
            guard let obj = obj else { return }
            return try onError(obj)()
        }
    }
}

// ******************************* MARK: - doOnCompleted

extension ObservableType {
    private func weakify<A: AnyObject>(_ obj: A, method: @escaping (A) -> () throws -> Void) -> (() throws -> Void) {
        return { [weak obj] () throws -> Void in
            guard let obj = obj else { return }
            return try method(obj)()
        }
    }
    
    /**
     Invokes an action on `weak` for completed event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onCompleted: Action to invoke on `weak` for completed event in the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnCompleted<A: AnyObject>(weak obj: A, _ onCompleted: @escaping (A) -> () throws -> Void) -> Observable<E> {
        return self.do(onCompleted: weakify(obj, method: onCompleted))
    }
    
    /**
     Invokes an action on `weak` for completed event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onCompleted: Action to invoke on `weak` for completed event in the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func doOnCompleted<A: AnyObject>(weak obj: A, _ onCompleted: @escaping (A) throws -> Void) -> Observable<E> {
        return doOnCompleted { [weak obj] () -> Void in
            guard let obj = obj else { return }
            return try onCompleted(obj)
        }
    }
}
