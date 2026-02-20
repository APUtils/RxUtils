//
//  ThrottledTap.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 3.08.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift
import UIKit

#if os(iOS)
public extension Reactive where Base: UIButton {
    
    /// Reactive wrapper for `TouchUpInside` control event with applied throttle to prevent double clicks.
    /// - parameter dueTime: Throttling duration for each element.
    func throttledTap(_ dueTime: RxTimeInterval = RxUtilsDefaults.tapThrottle) -> ControlEvent<Void> {
        ControlEvent(events: tap.throttle(dueTime, latest: false, scheduler: ConcurrentMainScheduler.instance))
    }
}
#endif

#if os(iOS) || os(tvOS)
public extension Reactive where Base: UIBarButtonItem {
    
    /// Reactive wrapper for target action pattern on `self` with applied throttle to prevent double clicks.
    /// - parameter dueTime: Throttling duration for each element.
    func throttledTap(_ dueTime: RxTimeInterval = RxUtilsDefaults.tapThrottle) -> ControlEvent<Void> {
        ControlEvent(events: tap.throttle(dueTime, latest: false, scheduler: ConcurrentMainScheduler.instance))
    }
}
#endif

#if canImport(UIKit)
public extension Reactive where Base: RxGestureView {
    
    /// Returns an observable `UITapGestureRecognizer` events sequence with applied throttle to prevent double clicks.
    /// - parameter dueTime: Throttling duration for each element.
    /// - parameter configuration: A closure that allows to fully configure the gesture recognizer
    func throttledTapGestureWhenRecognized(_ dueTime: RxTimeInterval = RxUtilsDefaults.tapThrottle,
                                           configuration: TapConfiguration? = nil) -> ControlEvent<Void> {
        
        ControlEvent(
            events: tapGesture(configuration: configuration)
                .when(.recognized)
                .throttle(dueTime, latest: false, scheduler: ConcurrentMainScheduler.instance)
                .mapToVoid()
        )
    }
    
    /// Returns an observable `UITapGestureRecognizer` events sequence with applied throttle to prevent double clicks.
    /// - parameter dueTime: Throttling duration for each element.
    /// - parameter configuration: A closure that allows to fully configure the gesture recognizer
    func throttledTapGestureWhenRecognizedWithRecognizer(_ dueTime: RxTimeInterval = RxUtilsDefaults.tapThrottle,
                                                         configuration: TapConfiguration? = nil) -> ControlEvent<UITapGestureRecognizer> {
        
        ControlEvent(
            events: tapGesture(configuration: configuration)
                .when(.recognized)
                .throttle(dueTime, latest: false, scheduler: ConcurrentMainScheduler.instance)
        )
    }
}
#endif
