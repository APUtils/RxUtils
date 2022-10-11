//
//  TimeZone+Rx.swift
//  Pods
//
//  Created by Anton Plebanovich on 11.10.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

extension TimeZone: ReactiveCompatible {}

public extension Reactive where Base == TimeZone {
    
    /// The time zone currently used by the system.
    /// Starts with current system time zone.
    /// - note: Observation happens on the main thread.
    static var current: Observable<TimeZone> {
        return NotificationCenter.default.rx.notification(NSNotification.Name.NSSystemTimeZoneDidChange)
            .map { _ in TimeZone.current }
            .startWithDeferred { TimeZone.current }
            .distinctUntilChanged()
            .observe(on: ConcurrentMainScheduler.instance)
    }
}
