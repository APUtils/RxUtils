//
//  UIApplication+Rx.swift
//  Turvo Driver
//
//  Created by Anton Plebanovich on 4/12/19.
//  Copyright © 2019 Turvo. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift


public extension Reactive where Base: UIApplication {
    
    /// UIApplication's state observable.
    /// Starts with current application's state.
    var applicationState: Observable<UIApplication.State> {
        return Observable
            .create { observer in
                let didEnterBackground = NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification)
                let didEnterBackgroundDisposable = didEnterBackground
                    .map { _ in UIApplication.shared.applicationState }
                    .subscribeOnNext(observer.onNext)
                
                let didBecomeActive = NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
                let didBecomeActiveDisposable = didBecomeActive
                    .map { _ in UIApplication.shared.applicationState }
                    .subscribeOnNext(observer.onNext)
                
                let willResignActive = NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification)
                let willResignActiveDisposable = willResignActive
                    .observeOn(MainScheduler.asyncInstance)
                    .map { _ in UIApplication.shared.applicationState }
                    .subscribeOnNext(observer.onNext)
                
                return CompositeDisposable(didEnterBackgroundDisposable, didBecomeActiveDisposable, willResignActiveDisposable)
            }
            .startWithDeferred(UIApplication.shared.applicationState)
    }
}
