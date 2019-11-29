//
//  RxSwift+Operators+ObservableType.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 7/15/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

public extension RxUtilsError {
    static let noElements: RxUtilsError = .init(code: 1, message: "Subscription was completed without emmiting any elements.")
}

public extension ObservableType {
    
    /// Projects each element of an observable sequence into Void
    func mapToVoid() -> Observable<Void> {
        return map { _ in () }
    }
    
    /// Throws `RxUtilsError.noElements` if sequence completed without emitting any elements.
    func errorIfNoElements() -> Observable<Element> {
        var gotElement = false
        
        return self
            .doOnNext { _ in
                gotElement = true
            }
            .doOnCompleted {
                if !gotElement {
                    throw RxUtilsError.noElements
                }
            }
    }
}
