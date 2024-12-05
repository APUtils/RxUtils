//
//  OperationsQueue.swift
//  Pods
//
//  Created by Anton Plebanovich on 5.12.24.
//  Copyright © 2024 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

public final class OperationsQueue {
    
    var operations = BehaviorRelay<[UUID]>(value: [])
    
    public init() {}
    
    public func addOperation(_ operation: Completable) -> Completable {
        let id = UUID()
        operations.accept(operations.value + [id])
        
        return operations
            .filter { $0.first == id }
            .asSafeSingle()
            .flatMapCompletable { [operations] _ in
                operation.doOnDispose {
                    operations.accept(Array(operations.value.dropFirst()))
                }
            }
    }
}
