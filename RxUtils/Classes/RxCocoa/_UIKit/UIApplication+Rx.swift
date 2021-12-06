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
    /// - note: Subscribe happens on the main thread.
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
                    .observe(on: MainScheduler.asyncInstance)
                    .map { _ in base.applicationState }
                    .subscribeOnNext(observer.onNext)
                
                return CompositeDisposable(didEnterBackgroundDisposable, didBecomeActiveDisposable, willResignActiveDisposable)
            }
            .startWithDeferred { [weak base] in base?.applicationState }
            .subscribe(on: ConcurrentMainScheduler.instance)
            .distinctUntilChanged()
    }
    
    /// Background refresh status observable.
    /// - note: Subscribe happens on the main thread.
    var backgroundRefreshStatus: Observable<UIBackgroundRefreshStatus> {
        NotificationCenter.default.rx.notification(UIApplication.backgroundRefreshStatusDidChangeNotification)
            .compactMap { [weak base] _ in base?.backgroundRefreshStatus }
            .startWithDeferred { [weak base] in base?.backgroundRefreshStatus }
            .subscribe(on: ConcurrentMainScheduler.instance)
            .distinctUntilChanged()
    }
    
    /// Reactive wrapper for `isFirstUnlockHappened` property.
    /// Starts with the current value.
    /// Completes after emitting `true`.
    var isFirstUnlockHappened: Observable<Bool> {
        NotificationCenter.default.rx.notification(UIApplication.protectedDataDidBecomeAvailableNotification)
            .mapTo(true)
            .startWithDeferred { [weak base] in base?.isFirstUnlockHappened }
            .take(until: { $0 }, behavior: .inclusive)
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
            .subscribe(on: ConcurrentMainScheduler.instance)
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
            .take(until: { $0.isReadable }, behavior: .inclusive)
    }
}

public extension UIApplication {
    
    enum KeychainState: Equatable, Comparable {
        case readable
        
        /// Keychain is not readable at the moment.
        /// Usually with `status: -25308 (User interaction is not allowed)`.
        /// The meaning of the `status` might be checked at the https://www.osstatus.com/
        case notReadable(status: OSStatus)
        
        public var isReadable: Bool {
            switch self {
            case .readable: return true
            default: return false
            }
        }
        
        public var status: OSStatus {
            switch self {
            case .readable: return errSecSuccess
            case .notReadable(let status): return status
            }
        }
    }
    
    fileprivate var keychainState: KeychainState {
        var commonQuery: [String: Any] = [:]
        commonQuery[String(kSecClass)] = String(kSecClassGenericPassword)
        commonQuery[String(kSecAttrSynchronizable)] = kSecAttrSynchronizableAny
        commonQuery[String(kSecAttrService)] = "RxUtils_service"
        commonQuery[String(kSecAttrAccount)] = "RxUtils_is_keychain_accessible_key"
        
        var readQuery: [String: Any] = commonQuery
        readQuery[String(kSecMatchLimit)] = kSecMatchLimitOne
        readQuery[String(kSecReturnData)] = kCFBooleanTrue
        
        var result: AnyObject?
        let status = SecItemCopyMatching(readQuery as CFDictionary, &result)
        
        if status == errSecSuccess {
            return .readable
            
        } else if status == errSecItemNotFound {
            // Add
            var writeQuery: [String: Any] = commonQuery
            writeQuery[String(kSecValueData)] = "value".data(using: .utf8, allowLossyConversion: true)
            writeQuery[String(kSecAttrAccessible)] = String(kSecAttrAccessibleAfterFirstUnlock)
            
            var result: AnyObject?
            let status = SecItemAdd(writeQuery as CFDictionary, &result)
            if status == errSecSuccess {
                return .readable
            } else {
                return .notReadable(status: status)
            }
            
        } else {
            return .notReadable(status: status)
        }
    }
}

// ******************************* MARK: - Did Leave Background

public extension Reactive where Base: UIApplication {
    
    /// Triggers event each time the app leaves the background.
    /// Event is a time interval that app spent in the background.
    /// - note: Useful to use for a refresh logic.
    /// - note: It doesn't trigger on the app start so preventing excessive updates.
    var didLeaveBackgroundWithTimeInterval: Observable<TimeInterval> {
        
        var _date = Date()
        let _recursiveLock = NSRecursiveLock()
        
        return applicationState
            .doOnNext { applicationState in
                if applicationState == UIApplication.State.background {
                    _recursiveLock.lock(); defer { _recursiveLock.unlock() }
                    _date = Date()
                }
            }
            .withRequiredPrevious()
            .filter { previous, _ in previous == UIApplication.State.background }
            .map { _ in
                _recursiveLock.lock(); defer { _recursiveLock.unlock() }
                return Date().timeIntervalSince(_date)
            }
            .doOnSubscribe {
                _recursiveLock.lock(); defer { _recursiveLock.unlock() }
                _date = Date()
            }
    }
    
    /// Triggers event each time the app leaves the background.
    /// - note: Useful to use for a refresh logic.
    /// - note: It doesn't trigger on the app start so preventing excessive updates.
    var didLeaveBackground: Observable<Void> {
        didLeaveBackgroundWithTimeInterval.mapToVoid()
    }
}

public extension ObservableType {
    
    /// Produces duplicate events on app leave background so UI may be reloaded for example.
    @available(iOSApplicationExtension, unavailable)
    func reloadOnLeaveBackground() -> Observable<Element> {
        Observable.combineLatest(UIApplication.shared.rx.didLeaveBackgroundWithTimeInterval.startWith(0),
                                 self)
            .map { $1 }
    }
}

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    
    /// Produces duplicate events on app leave background so UI may be reloaded for example.
    @available(iOSApplicationExtension, unavailable)
    func reloadOnLeaveBackground() -> Driver<Element> {
        asObservable()
            .reloadOnLeaveBackground()
            .asDriver(onErrorDriveWith: .empty())
    }
}

