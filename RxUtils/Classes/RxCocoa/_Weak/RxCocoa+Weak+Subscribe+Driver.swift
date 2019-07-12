//
//  RxCocoa+Weak+Subscribe+Driver.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 7/12/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

// ******************************* MARK: - driveOnNext

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    private func weakify<A: AnyObject>(_ obj: A, method: @escaping (A) -> (Element) -> Void) -> ((Element) -> Void) {
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
    func driveOnNext<A: AnyObject>(weak obj: A, _ onNext: @escaping (A) -> (Element) -> Void) -> Disposable {
        return drive(onNext: weakify(obj, method: onNext))
    }
    
    /**
     Subscribes and invokes an action on `weak` for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onNext: Action to invoke on `weak` for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func driveOnNext<A: AnyObject>(weak obj: A, _ onNext: @escaping (A, Element) -> Void) -> Disposable {
        return driveOnNext { [weak obj] element -> Void in
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
    func driveOnNext<A: AnyObject>(weak obj: A, _ onNext: @escaping (A) -> () -> Void) -> Disposable {
        return driveOnNext { [weak obj] _ in
            guard let obj = obj else { return }
            return onNext(obj)()
        }
    }
}

// ******************************* MARK: - Void Support

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element == Void {
    
    /**
     Subscribes and invokes an action on `weak` for each event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onNext: Action to invoke on `weak` for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func driveOnNext<A: AnyObject>(weak obj: A, _ onNext: @escaping (A) -> Void) -> Disposable {
        return driveOnNext { [weak obj] _ -> Void in
            guard let obj = obj else { return }
            return onNext(obj)
        }
    }
}
