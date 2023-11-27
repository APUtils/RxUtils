//
//  BehaviorRelay+Utils.swift
//  Pods
//
//  Created by Anton Plebanovich on 27.11.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

import RxSwift
import RxRelay

public extension BehaviorRelay {
    
    func asBinder() -> Binder<Element> {
        Binder(self, scheduler: ConcurrentMainScheduler.instance) {
            $0.accept($1)
        }
    }
}
