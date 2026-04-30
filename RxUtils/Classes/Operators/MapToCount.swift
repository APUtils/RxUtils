//
//  MapToCount.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 25.08.24.
//  Copyright © 2024 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

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
    
    /// Projects each element of an observable sequence into tuple of the element with its occurrence number starting from 1
    func withCount() -> Observable<(Element, Int)> {
        var count = 0
        let lock = NSLock()
        return map { element in
            lock.withLock {
                count += 1
                return (element, count)
            }
        }
    }
}
