//
//  RxCocoa+Error+Single.swift
//  RxSwift
//
//  Created by Anton Plebanovich on 12/12/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

public extension PrimitiveSequence where Trait == SingleTrait {
    /// Maps error into other error.
    /// - parameter transform: A transform function to apply to source error.
    func mapError(_ transform: @escaping (Error) -> Error) -> Single<Element> {
        return self.catch { error -> Single<Element> in .error(transform(error)) }
    }
    
    /// Maps error into other error.
    /// - parameter error: Error to transform to.
    func mapErrorTo(_ error: Error) -> Single<Element> {
        return self.catch { _ -> Single<Element> in .error(error) }
    }
    
    /// Retries sequence if condition is met.
    func retryIf(_ if: @escaping (Error) -> Bool) -> Single<Element> {
        asObservable()
            .retryIf(`if`)
            .asSingle()
    }
    
    /// Reports an error if a sequence receives an error. Crashes during debug.
    func assertNoErrors(file: String = #file, function: String = #function, line: UInt = #line) -> Single<Element> {
        asObservable()
            .assertNoErrors(file: file, function: function, line: line)
            .asSingle()
    }
}
