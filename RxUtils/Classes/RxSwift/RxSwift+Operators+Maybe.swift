//
//  RxSwift+Operators+Maybe.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 2/27/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

public extension PrimitiveSequence where Trait == MaybeTrait {
    
    /// Projects each element of an observable sequence into Void
    func mapToVoid() -> Maybe<Void> {
        return map { _ in () }
    }
    
    /// Creates sequence that can not be canceled
    func preventCancellation() -> Maybe<Element> {
        return .create { observer in
            _ = self.subscribe(observer)
            return Disposables.create()
        }
    }
    
    /// Wraps element into optional
    func wrapIntoOptional() -> Maybe<Element?> {
        return map { $0 }
    }
}
