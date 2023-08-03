//
//  ThrottledTap.swift
//  Pods
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
    func throttledTap(_ dueTime: RxTimeInterval = .milliseconds(500)) -> Observable<Void> {
        tap.throttle(dueTime, latest: false, scheduler: MainScheduler.instance)
    }
}
#endif

#if os(iOS) || os(tvOS)
public extension Reactive where Base: UIBarButtonItem {
    
    /// Reactive wrapper for target action pattern on `self` with applied throttle to prevent double clicks.
    /// - parameter dueTime: Throttling duration for each element.
    func throttledTap(_ dueTime: RxTimeInterval = .milliseconds(500)) -> Observable<Void> {
        tap.throttle(dueTime, latest: false, scheduler: MainScheduler.instance)
    }
}
#endif

#if canImport(UIKit)
public extension Reactive where Base: RxGestureView {
    
    /// Returns an observable `UITapGestureRecognizer` events sequence with applied throttle to prevent double clicks.
    /// - parameter dueTime: Throttling duration for each element.
    /// - parameter configuration: A closure that allows to fully configure the gesture recognizer
    func throttledTapGestureWhenRecognized(_ dueTime: RxTimeInterval = .milliseconds(500),
                                           configuration: TapConfiguration? = nil) -> Observable<Void> {
        
        tapGesture(configuration: configuration)
            .when(.recognized)
            .throttle(dueTime, latest: false, scheduler: MainScheduler.instance)
            .mapToVoid()
    }
    
    /// Returns an observable `UITapGestureRecognizer` events sequence with applied throttle to prevent double clicks.
    /// - parameter dueTime: Throttling duration for each element.
    /// - parameter configuration: A closure that allows to fully configure the gesture recognizer
    func throttledTapGestureWhenRecognizedWithRecognizer(_ dueTime: RxTimeInterval = .milliseconds(500),
                                                         configuration: TapConfiguration? = nil) -> Observable<UITapGestureRecognizer> {
        
        tapGesture(configuration: configuration)
            .when(.recognized)
            .throttle(dueTime, latest: false, scheduler: MainScheduler.instance)
    }
}
#endif
