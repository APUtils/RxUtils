//
//  MapToCount.swift
//  Pods
//
//  Created by Anton Plebanovich on 25.08.24.
//  Copyright © 2024 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// ******************************* MARK: - Maybe

public extension PrimitiveSequence where Trait == MaybeTrait {
    
    /// Projects each element of an observable sequence into its occurrence number starting from 1
    func mapToCount() -> Maybe<Int> {
        asObservable()
            .mapToCount()
            .asMaybe()
    }
}

// ******************************* MARK: - Single

public extension PrimitiveSequence where Trait == SingleTrait {
    
    /// Projects each element of an observable sequence into its occurrence number starting from 1
    func mapToCount() -> Single<Int> {
        asObservable()
            .mapToCount()
            .asSingle()
    }
}

// ******************************* MARK: - Signal

public extension SharedSequenceConvertibleType where SharingStrategy == SignalSharingStrategy {
    
    /// Projects each element of an observable sequence into its occurrence number starting from 1
    func mapToCount() -> Signal<Int> {
        asObservable()
            .mapToCount()
            .asSignal(onErrorSignalWith: .empty())
    }
}

// ******************************* MARK: - ObservableType

public extension ObservableType {
    
    /// Projects each element of an observable sequence into its occurrence number starting from 1
    func mapToCount() -> Observable<Int> {
        var count = 0
        let lock = NSLock()
        return map { _ in
            lock.withLock {
                count += 1
                return count
            }
        }
    }
}
