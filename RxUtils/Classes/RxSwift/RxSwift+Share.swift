//
//  RxSwift+Share.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 05.12.24.
//  Copyright © 2024 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

public extension Completable {
    
    func share(scope: SubjectLifetimeScope = .whileConnected) -> Completable {
        asObservable()
            .share(replay: 0, scope: scope)
            .asCompletable()
    }
}
