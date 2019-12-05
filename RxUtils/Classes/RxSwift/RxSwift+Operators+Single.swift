//
//  RxSwift+Operators+Single.swift
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
}
