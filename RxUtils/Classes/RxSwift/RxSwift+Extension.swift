//
//  RxSwift+Extension.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 4/12/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift


public extension ObservableType {
    
    /// Apply filter to sequence using second sequence.
    /// - parameter second: Sequence to use for comparison.
    /// - parameter comparer: Equality comparer for computed key values.
    /// - returns: Filtered sequence.
    func filterWithLatestFrom<T>(_ second: Observable<T>, _ comparer: @escaping (E, T) -> Bool) -> Observable<E> {
        return withLatestFrom(second) { ($0, $1) }
            .filter { comparer($0.0, $0.1) }
            .map { $0.0 }
    }
}

public extension ObservableType where E: Equatable {
    
    /// Filters out element if it equals to the latest from provided sequence.
    /// - parameter second: Sequence to use for comparison.
    /// - returns: Filtered sequence.
    func filterEqualWithLatestFrom(_ second: Observable<E>) -> Observable<E> {
        return withLatestFrom(second) { ($0, $1) }
            .filter { $0 != $1 }
            .map { $0.0 }
    }
}
