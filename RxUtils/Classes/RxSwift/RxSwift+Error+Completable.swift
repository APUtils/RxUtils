//
//  RxSwift+Error+Completable.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 4/17/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

public extension PrimitiveSequence where Trait == RxSwift.CompletableTrait, Element == Never {
    
    /// Maps error into other error.
    /// - parameter transform: A transform function to apply to source error.
    func mapError(_ transform: @escaping (Error) -> Error) -> Completable {
        return self.catch { error -> Completable in .error(transform(error)) }
    }
    
    /// Maps error into other error.
    /// - parameter error: Error to transform to.
    func mapErrorTo(_ error: Error) -> Completable {
        return self.catch { error -> Completable in .error(error) }
    }
    
    /// Just completes a sequence on an error.
    func catchErrorJustComplete() -> Completable {
        self.catch { _ in Completable.empty() }
    }
}
