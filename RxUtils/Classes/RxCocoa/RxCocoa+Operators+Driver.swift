//
//  RxCocoa+Operators+Driver.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 14.11.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element: Collection {
    /**
     Projects each element of an observable collection into a new form.
     
     - parameter transform: A transform function to apply to each element of the source collection.
     - returns: An observable collection whose elements are the result of invoking the transform function on each element of source.
     */
    func mapMany<Result>(_ transform: @escaping (Element.Element) -> Result) -> Driver<[Result]> {
        map { collection -> [Result] in
            collection.map(transform)
        }
    }
}
