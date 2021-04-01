//
//  UIApplication+Rx.swift
//  Turvo Driver
//
//  Created by Anton Plebanovich on 4/12/19.
//  Copyright © 2019 Turvo. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

public extension Reactive where Base: UIApplication {
    
    /// UIApplication's state observable.
    /// Starts with current application's state.
    var applicationState: Observable<UIApplication.State> {
        return Observable
            .create { [base] observer in
                let didEnterBackground = NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification)
                let didEnterBackgroundDisposable = didEnterBackground
                    .map { _ in base.applicationState }
                    .subscribeOnNext(observer.onNext)
                
                let didBecomeActive = NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
                let didBecomeActiveDisposable = didBecomeActive
                    .map { _ in base.applicationState }
                    .subscribeOnNext(observer.onNext)
                
                let willResignActive = NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification)
                let willResignActiveDisposable = willResignActive
                    .observeOn(MainScheduler.asyncInstance)
                    .map { _ in base.applicationState }
                    .subscribeOnNext(observer.onNext)
                
                return CompositeDisposable(didEnterBackgroundDisposable, didBecomeActiveDisposable, willResignActiveDisposable)
            }
            .startWithDeferred { [weak base] in base?.applicationState }
            .distinctUntilChanged()
    }
    
    /// Background refresh status observable.
    var backgroundRefreshStatus: Observable<UIBackgroundRefreshStatus> {
        NotificationCenter.default.rx.notification(UIApplication.backgroundRefreshStatusDidChangeNotification)
            .compactMap { [weak base] _ in base?.backgroundRefreshStatus }
            .startWithDeferred { [weak base] in base?.backgroundRefreshStatus }
            .distinctUntilChanged()
    }
    
    /// Reactive wrapper for `isFirstUnlockHappened` property.
    /// Starts with the current value.
    /// Completes after emitting `true`.
    var isFirstUnlockHappened: Observable<Bool> {
        NotificationCenter.default.rx.notification(UIApplication.protectedDataDidBecomeAvailableNotification)
            .mapTo(true)
            .startWithDeferred { [weak base] in base?.isFirstUnlockHappened }
            .takeUntil(.inclusive) { $0 }
    }
    
    /// Reactive wrapper for `isProtectedDataAvailable` property.
    /// Basically, it's device lock/unlock status.
    var isProtectedDataAvailable: Observable<Bool> {
        let available = NotificationCenter.default.rx.notification(UIApplication.protectedDataDidBecomeAvailableNotification)
            .mapTo(true)
        
        let unavailable = NotificationCenter.default.rx.notification(UIApplication.protectedDataWillBecomeUnavailableNotification)
            .mapTo(false)
        
        return Observable.merge(available, unavailable)
            .startWithDeferred { [weak base] in base?.isProtectedDataAvailable }
            .distinctUntilChanged()
    }
}

fileprivate extension UIApplication {
    
    /// Checks if the first unlock happeded.
    var isFirstUnlockHappened: Bool {
        let tempFilePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).path
        let attributes = [FileAttributeKey.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication]
        let isFirstUnlockHappened = FileManager.default.createFile(atPath: tempFilePath, contents: nil, attributes: attributes)
        if isFirstUnlockHappened {
            return true
            
        } else {
            return false
        }
    }
}

// ******************************* MARK: - Keychain

public extension Reactive where Base: UIApplication {
    
    /// Each second checks for the keychain readable state and fires an event if it changes.
    /// Starts with the current value.
    /// Completes after emitting `.readable`.
    var isKeychainReadable: Observable<Base.KeychainState> {
        Observable<Int>.timer(.seconds(1),
                         period: .seconds(1),
                         scheduler: MainScheduler.instance)
            .map { [base] _ in base.keychainState }
            .startWithDeferred { [base] in base.keychainState }
            .distinctUntilChanged()
            .takeUntil(.inclusive) { $0.isReadable }
    }
}

public extension UIApplication {
    
    enum KeychainState: Equatable, Comparable {
        case readable
        case notReadable(status: OSStatus)
        
        var isReadable: Bool {
            switch self {
            case .readable: return true
            default: return false
            }
        }
    }
    
    fileprivate var keychainState: KeychainState {
        var query: [String: Any] = [:]
        query[String(kSecClass)] = String(kSecClassGenericPassword)
        query[String(kSecAttrSynchronizable)] = kSecAttrSynchronizableAny
        query[String(kSecAttrService)] = "RxUtils_service"
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecAttrAccount)] = "RxUtils_is_keychain_accessible_key"
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecSuccess || status == errSecItemNotFound {
            return .readable
        } else {
            return .notReadable(status: status)
        }
    }
}
