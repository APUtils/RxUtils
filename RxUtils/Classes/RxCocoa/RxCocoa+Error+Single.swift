//
//  RxCocoa+Error+Single.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 12/12/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//


import Foundation
import RxCocoa
import RxSwift

public extension PrimitiveSequence where Trait == SingleTrait {
    /// Maps error into other error.
    /// - parameter transform: A transform function to apply to source error.
    func mapError(_ transform: @escaping (Error) -> Error) -> Single<Element> {
        return self.catchError { error -> Single<Element> in .error(transform(error)) }
    }
    
    /// Maps error into other error.
    /// - parameter error: Error to transform to.
    func mapErrorTo(_ error: Error) -> Single<Element> {
        return self.catchError { error -> Single<Element> in .error(error) }
    }
}
