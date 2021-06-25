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
    
    /// Just completes a sequence on an error.
    func catchErrorJustComplete() -> Completable {
        self.catch { _ in Completable.empty() }
    }
}
