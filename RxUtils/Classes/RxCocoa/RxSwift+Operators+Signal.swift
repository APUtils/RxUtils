//
//  RxSwift+Operators+Signal.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 7/29/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public extension SharedSequenceConvertibleType where SharingStrategy == SignalSharingStrategy {
    
    /// Projects each element of an signal sequence into Void
    func mapToVoid() -> Signal<Void> {
        return map { _ in () }
    }
}
