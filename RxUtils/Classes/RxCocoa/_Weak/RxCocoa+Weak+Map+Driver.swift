//
//  RxCocoa+Weak+Map+Driver.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 5/21/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    
    fileprivate func weakify<A: AnyObject, B>(_ obj: A, method: @escaping (A) -> (Element) -> B) -> ((Element) -> B?) {
        return { [weak obj] value -> B? in
            guard let obj = obj else { return nil }
            return method(obj)(value)
        }
    }
    
    /**
     Projects each element of an observable sequence into a new form.
     
     - seealso: [map operator on reactivex.io](http://reactivex.io/documentation/operators/map.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter transform: A transform function to apply on `weak` to each source element.
     - returns: An observable sequence whose elements are the result of invoking the transform function on each element of source.
     */
    func map<A: AnyObject, B>(weak obj: A, _ transform: @escaping (A) -> (Element) -> B) -> Driver<B> {
        return compactMap(weakify(obj, method: transform))
    }
    
    /**
     Projects each element of an observable sequence into a new form.
     
     - seealso: [map operator on reactivex.io](http://reactivex.io/documentation/operators/map.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter transform: A transform function to apply on `weak` to each source element.
     - returns: An observable sequence whose elements are the result of invoking the transform function on each element of source.
     */
    func map<A: AnyObject, B>(weak obj: A, _ transform: @escaping (A, Element) -> B) -> Driver<B> {
        return compactMap { [weak obj] element -> B? in
            guard let obj = obj else { return nil }
            return transform(obj, element)
        }
    }
}
