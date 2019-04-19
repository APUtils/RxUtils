//
//  RxSwift+Weak+Subscribe.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 4/12/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

// ******************************* MARK: - subscribeOnNext

public extension ObservableType {
    private func weakify<A: AnyObject>(_ obj: A, method: @escaping (A) -> (E) -> Void) -> ((E) -> Void) {
        return { [weak obj] value -> Void in
            guard let obj = obj else { return }
            return method(obj)(value)
        }
    }
    
    /**
     Subscribes and invokes an action on `weak` for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onNext: Action to invoke on `weak` for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func subscribeOnNext<A: AnyObject>(weak obj: A, _ onNext: @escaping (A) -> (E) -> Void) -> Disposable {
        return subscribe(onNext: weakify(obj, method: onNext))
    }
    
    /**
     Subscribes and invokes an action on `weak` for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onNext: Action to invoke on `weak` for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func subscribeOnNext<A: AnyObject>(weak obj: A, _ onNext: @escaping (A, E) -> Void) -> Disposable {
        return subscribeOnNext { [weak obj] element -> Void in
            guard let obj = obj else { return }
            return onNext(obj, element)
        }
    }
    
    /**
     Subscribes and invokes an action on `weak` for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onNext: Action to invoke on `weak` for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func subscribeOnNext<A: AnyObject>(weak obj: A, _ onNext: @escaping (A) -> () -> Void) -> Disposable {
        return subscribeOnNext { [weak obj] _ in
            guard let obj = obj else { return }
            return onNext(obj)()
        }
    }
}

// ******************************* MARK: - Void Support

extension ObservableType where E == Void {
    
    /**
     Subscribes and invokes an action on `weak` for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onNext: Action to invoke on `weak` for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func subscribeOnNext<A: AnyObject>(weak obj: A, _ onNext: @escaping (A) -> Void) -> Disposable {
        return subscribeOnNext { [weak obj] _ -> Void in
            guard let obj = obj else { return }
            return onNext(obj)
        }
    }
}
