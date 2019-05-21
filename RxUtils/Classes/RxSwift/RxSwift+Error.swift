//
//  RxSwift+Error.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 4/11/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift


public extension ObservableType {
    /// Maps error into other error.
    /// - parameter transform: A transform function to apply to source error.
    func mapError(_ transform: @escaping (Error) -> Error) -> Observable<Element> {
        return self.catchError { error -> Observable<Element> in .error(transform(error)) }
    }
    
    /// Maps error into other error.
    /// - parameter error: Error to transform to.
    func mapErrorTo(_ error: Error) -> Observable<Element> {
        return self.catchError { error -> Observable<Element> in .error(error) }
    }
}
