//
//  RxCocoa+CompactMap+Driver.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 5/21/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxCocoa
import RxOptional
import RxSwift


public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    /**
     Projects each element of an observable sequence into a new form. If transforms produces a `nil` those elements are filtered out.
     
     - seealso: [map operator on reactivex.io](http://reactivex.io/documentation/operators/map.html)
     
     - parameter transform: A transform function to apply to each source element. If `nil` is returned element will be filtered out.
     - returns: An observable sequence whose elements are the result of invoking the transform function on each element of source.
     
     */
    func compactMap<T>(_ transform: @escaping (Element) -> T?) -> Driver<T> {
        return map(transform)
            .filterNil()
    }
}
