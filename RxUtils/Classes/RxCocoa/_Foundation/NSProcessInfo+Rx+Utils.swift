//
//  NSProcessInfo+Rx+Utils.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 10/2/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public extension Reactive where Base: ProcessInfo {
    
    /// Reactive wrapper for a `lowPowerModeEnabled` property.
    var lowPowerModeEnabled: Observable<Bool> {
        return NotificationCenter.default.rx.notification(.NSProcessInfoPowerStateDidChange)
            .map { [base] _ in base.isLowPowerModeEnabled }
            .startWithDeferred { [weak base] in base?.isLowPowerModeEnabled }
            .distinctUntilChanged()
            // Notification isn't comming from the main thread =\
            .observe(on: ConcurrentMainScheduler.instance)
    }
}
