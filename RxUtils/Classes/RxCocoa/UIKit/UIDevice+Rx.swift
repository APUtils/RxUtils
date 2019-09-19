//
//  UIDevice+Rx.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 9/19/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

public extension Reactive where Base: UIDevice {
    
    /// Reactive wrapper for a `batteryState`.
    /// Be sure to set `UIDevice.current.isBatteryMonitoringEnabled = true` to be able to observe updates.
    var batteryState: Observable<UIDevice.BatteryState> {
        return NotificationCenter.default.rx.notification(UIDevice.batteryStateDidChangeNotification)
            .map { _ in UIDevice.current.batteryState }
            .startWithDeferred(UIDevice.current.batteryState)
            .distinctUntilChanged()
    }
    
    /// Reactive wrapper for a `batteryLevel`.
    /// Be sure to set `UIDevice.current.isBatteryMonitoringEnabled = true` to be able to observe updates.
    var batteryLevel: Observable<Float> {
        return NotificationCenter.default.rx.notification(UIDevice.batteryLevelDidChangeNotification)
            .map { _ in UIDevice.current.batteryLevel }
            .startWithDeferred(UIDevice.current.batteryLevel)
            .distinctUntilChanged()
    }
}
