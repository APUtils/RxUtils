//
//  RxSwift+SkipFirst.swift
//  Pods
//
//  Created by Anton Plebanovich on 12/17/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

public extension ObservableType {
    
    /// Skips the first element in a sequence if predicate matches.
    func skipFirstIf(_ predicate: @escaping (Element) -> Bool) -> Observable<Element> {
        
        var _first = true
        let _recursiveLock = NSRecursiveLock()
        
        return filter {
            _recursiveLock.lock(); defer { _recursiveLock.unlock() }
            let skip = _first && predicate($0)
            _first = false
            return !skip
        }
    }
}

public extension ObservableType where Element == Bool {
    
    /// Skips the first element if it's `false`.
    func skipFirstIfFalse() -> Observable<Element> {
        skipFirstIf { !$0 }
    }
}
