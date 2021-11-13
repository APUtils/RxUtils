//
//  RxSwift+Maybe.swift
//  Pods
//
//  Created by Anton Plebanovich on 14.11.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift


public extension PrimitiveSequence where Trait == MaybeTrait {
    
    /**
     Projects each element of an observable sequence to an observable sequence and merges the resulting observable sequences into one observable sequence.
     
     - seealso: [flatMap operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
     
     - parameter selector: A transform function to apply to each element.
     - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each element of the input sequence.
     */
    func flatMapCompletable(_ selector: @escaping (Element) throws -> Completable) -> Completable {
        asObservable()
            .flatMap(selector)
            .asCompletable()
    }
    
}
