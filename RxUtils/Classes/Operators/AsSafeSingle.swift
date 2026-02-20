//
//  AsSafeSingle.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 20.02.26.
//  Copyright © 2026 Anton Plebanovich. All rights reserved.
//

import RxCocoa
import RxSwift

// ******************************* MARK: - ObservableType<Element>

public extension ObservableType {
    
    /// Same as `asSingle()` but completes right after gets the first element.
    /// Ordinary `asSingle()` waits for the completion event.
    func asSafeSingle() -> Single<Element> {
        return self
            .take(1)
            .asSingle()
    }
}

// ******************************* MARK: - Driver<Element>

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    
    /// Same as `asSingle()` but completes right after gets the first element.
    /// Ordinary `asSingle()` waits for the completion event.
    func asSafeSingle() -> Single<Element> {
        return self
            .asObservable()
            .asSafeSingle()
    }
}
