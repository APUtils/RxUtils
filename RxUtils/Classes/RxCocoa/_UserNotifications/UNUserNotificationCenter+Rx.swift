//
//  UNUserNotificationCenter+Rx.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 24.07.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

import UserNotifications
import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UNUserNotificationCenter {
    
    /// Returns `true` if `authorizationStatus` is `.authorized`, `.provisional`, or `.ephemeral`.
    /// - returns: `Observable` on the `main` queue.
    var authorized: Observable<Bool> {
        _authorizationStatus
            .map { authorizationStatus in
                var authorized = authorizationStatus == .authorized
                if #available(iOS 12.0, *) {
                    authorized = authorized || authorizationStatus == .provisional
                }
                if #available(iOS 14.0, *) {
                    authorized = authorized || authorizationStatus == .ephemeral
                }
                
                return authorized
            }
            .distinctUntilChanged()
            .observe(on: ConcurrentMainScheduler.instance)
    }
    
    /// Reactive wrapper for the `authorizationStatus` of notification settings
    /// - returns: `Observable` on the `main` queue.
    var authorizationStatus: Observable<UNAuthorizationStatus> {
        _authorizationStatus
            .observe(on: ConcurrentMainScheduler.instance)
    }
    
    fileprivate var _authorizationStatus: Observable<UNAuthorizationStatus> {
        UIApplication.shared.rx.applicationState
            .filter { $0 == .active }
            .flatMapLatest { _ in _getNotificationSettings() }
            .map { $0.authorizationStatus }
            .distinctUntilChanged()
    }
    
    /// Retrieves the authorization and feature-related settings for your app.
    /// - returns: `Single` on the `main` queue.
    func getNotificationSettings() -> Single<UNNotificationSettings> {
        _getNotificationSettings()
            .observe(on: ConcurrentMainScheduler.instance)
    }
    
    fileprivate func _getNotificationSettings() -> Single<UNNotificationSettings> {
        Single
            .create { observer in
                base.getNotificationSettings { settings in
                    observer(.success(settings))
                }
                
                return Disposables.create()
            }
            .observe(on: ConcurrentMainScheduler.instance)
    }
}
