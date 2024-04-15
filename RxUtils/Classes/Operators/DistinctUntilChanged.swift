//
//  DistinctUntilChanged.swift
//  Pods
//
//  Created by Anton Plebanovich on 15.04.24.
//  Copyright © 2024 Anton Plebanovich. All rights reserved.
//

import RxSwift

// ******************************* MARK: - ObservableConvertibleType

public extension ObservableConvertibleType {
    
    func distinctUntilChanged<T: Equatable, Y: Equatable>() -> Observable<Element> where Element == (T, Y) {
        asObservable()
            .distinctUntilChanged()
    }
}

// ******************************* MARK: - ObservableType

public extension ObservableType {
    
    func distinctUntilChanged<T: Equatable, Y: Equatable>() -> Observable<Element> where Element == (T, Y) {
        distinctUntilChanged { lhs, rhs in
            lhs.0 == rhs.0 && lhs.1 == rhs.1
        }
    }
}
