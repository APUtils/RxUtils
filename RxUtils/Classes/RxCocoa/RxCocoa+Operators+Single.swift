//
//  RxCocoa+Operators+Single.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 12/5/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

public extension PrimitiveSequence where Trait == SingleTrait {
    
    /// Projects each element of an observable sequence into Void
    func mapToVoid() -> Single<Void> {
        return map { _ in () }
    }

    /// Creates sequence that can not be canceled
    func preventCancellation() -> Single<Element> {
        return .create { observer in
            _ = self.subscribe(observer)
            return Disposables.create()
        }
    }
    
    /// Wraps element into optional
    func wrapIntoOptional() -> Single<Element?> {
        return map { $0 }
    }
}