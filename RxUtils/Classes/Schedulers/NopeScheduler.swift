//
//  NopeScheduler.swift
//  Pods
//
//  Created by Anton Plebanovich on 19.05.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

import RxSwift

/// Just performs operation immediatelly instead of scheduling it somehow.
public final class NopeScheduler: ImmediateSchedulerType {
    public func schedule<StateType>(_ state: StateType, action: @escaping (StateType) -> Disposable) -> Disposable {
        return action(state)
    }
}

// ******************************* MARK: - Sigletone

public extension NopeScheduler {
    static let instance = NopeScheduler()
}
