//
//  RxSwift+Operators+ObservableType.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 7/15/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

public extension ObservableType {
    
    /// Projects each element of an observable sequence into Void
    func mapToVoid() -> Observable<Void> {
        return map { _ in () }
    }
}
