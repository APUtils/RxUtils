//
//  UIDevice+Rx.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 9/19/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

public extension Reactive where Base: UIDevice {
    
    /// Reactive wrapper for a `batteryState` property.
    /// Be sure to set `UIDevice.current.isBatteryMonitoringEnabled = true` to be able to observe updates.
    var batteryState: Observable<UIDevice.BatteryState> {
        return NotificationCenter.default.rx.notification(UIDevice.batteryStateDidChangeNotification)
            .map { [base] _ in base.batteryState }
            .startWithDeferred { [weak base] in base?.batteryState }
            .distinctUntilChanged()
    }
    
    /// Reactive wrapper for a `batteryLevel` property.
    /// Be sure to set `UIDevice.current.isBatteryMonitoringEnabled = true` to be able to observe updates.
    var batteryLevel: Observable<Float> {
        return NotificationCenter.default.rx.notification(UIDevice.batteryLevelDidChangeNotification)
            .map { [base] _ in base.batteryLevel }
            .startWithDeferred { [weak base] in base?.batteryLevel }
            .distinctUntilChanged()
    }
}
