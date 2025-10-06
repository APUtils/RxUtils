//
//  UIApplication+Rx.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 4/12/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import RoutableLogger
import RxCocoa
import RxSwift
import RxSwiftExt
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
            .distinctUntilChanged()
            .subscribe(on: ConcurrentMainScheduler.instance)
    }
    
    /// Background refresh status observable.
    /// - note: Subscribe happens on the main thread.
    var backgroundRefreshStatus: Observable<UIBackgroundRefreshStatus> {
        NotificationCenter.default.rx.notification(UIApplication.backgroundRefreshStatusDidChangeNotification)
            .compactMap { [weak base] _ in base?.backgroundRefreshStatus }
            .startWithDeferred { [weak base] in base?.backgroundRefreshStatus }
            .distinctUntilChanged()
            .subscribe(on: ConcurrentMainScheduler.instance)
    }
    
    /// Reactive wrapper for `isFirstUnlockHappened` property.
    /// Starts with the current value.
    /// Completes after emitting `true`.
    var isFirstUnlockHappened: Observable<Bool> {
        let protectedDataDidBecomeAvailable = NotificationCenter.default.rx
            .notification(UIApplication.protectedDataDidBecomeAvailableNotification)
            .mapTo(true)
        
        let didLeaveBackground = didLeaveBackground
            .compactMap { [weak base] in base?.isFirstUnlockHappened }
        
        return Observable.merge(protectedDataDidBecomeAvailable, didLeaveBackground)
            .startWithDeferred { [weak base] in base?.isFirstUnlockHappened }
            .distinctUntilChanged()
            .take(until: { $0 }, behavior: .inclusive)
            .subscribe(on: ConcurrentMainScheduler.instance)
    }
    
    /// Reactive wrapper for `isProtectedDataAvailable` property.
    /// Basically, it's device lock/unlock status.
    var isProtectedDataAvailable: Observable<Bool> {
        let available = NotificationCenter.default.rx.notification(UIApplication.protectedDataDidBecomeAvailableNotification)
            .mapTo(true)
        
        let unavailable = NotificationCenter.default.rx.notification(UIApplication.protectedDataWillBecomeUnavailableNotification)
            .mapTo(false)
        
        let didLeaveBackground = didLeaveBackground
            .compactMap { [weak base] in base?.isProtectedDataAvailable }
        
        return Observable.merge(available, unavailable, didLeaveBackground)
            .startWithDeferred { [weak base] in base?.isProtectedDataAvailable }
            .distinctUntilChanged()
            .subscribe(on: ConcurrentMainScheduler.instance)
    }
}

fileprivate extension UIApplication {
    
    /// Checks if the first unlock happened.
    /// - note: Returns `true` if there is low space on disk because check is not possible in that condition.
    var isFirstUnlockHappened: Bool {
        // We can't create file if there is no space on disk so we skip the check for this case.
        if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) {
            let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value ?? 0
            if freeSpace < 104_857_600 {
                return true
            }
        }
        
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
                         scheduler: ConcurrentMainScheduler.instance)
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
        /// Other: `-25291 (Not available)`
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
        
        public var statusMessage: String? {
            if #available(iOS 11.3, *) {
                return SecCopyErrorMessageString(status, nil) as String?
            } else {
                return nil
            }
        }
    }
    
    fileprivate var keychainState: KeychainState {
        let readStatus = readItem()
        if readStatus == errSecSuccess {
            // Exists. Delete and add.
            let deleteStatus = deleteItem()
            if deleteStatus == errSecSuccess {
                return addItemAndReturnState()
                
            } else {
                return .notReadable(status: deleteStatus)
            }
            
        } else if readStatus == errSecItemNotFound {
            // Not exists. Add
            return addItemAndReturnState()
            
        } else {
            return .notReadable(status: readStatus)
        }
    }
    
    fileprivate var commonQuery: [String: Any] {
        var commonQuery: [String: Any] = [:]
        commonQuery[String(kSecClass)] = String(kSecClassGenericPassword)
        commonQuery[String(kSecAttrSynchronizable)] = kSecAttrSynchronizableAny
        commonQuery[String(kSecAttrService)] = "RxUtils_service"
        commonQuery[String(kSecAttrAccount)] = "RxUtils_is_keychain_accessible_key"
        
        return commonQuery
    }
    
    fileprivate func addItemAndReturnState() -> KeychainState {
        let addStatus = addItem()
        if addStatus == errSecSuccess {
            return .readable
        } else {
            return .notReadable(status: addStatus)
        }
    }
    
    fileprivate func addItem() -> OSStatus {
        var writeQuery: [String: Any] = commonQuery
        writeQuery[String(kSecValueData)] = "value".data(using: .utf8, allowLossyConversion: true)
        writeQuery[String(kSecAttrAccessible)] = String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
        
        var result: AnyObject?
        return SecItemAdd(writeQuery as CFDictionary, &result)
    }
    
    fileprivate func readItem() -> OSStatus {
        var readQuery: [String: Any] = commonQuery
        readQuery[String(kSecMatchLimit)] = kSecMatchLimitOne
        readQuery[String(kSecReturnData)] = kCFBooleanTrue
        
        var result: AnyObject?
        return SecItemCopyMatching(readQuery as CFDictionary, &result)
    }
    
    fileprivate func deleteItem() -> OSStatus {
        return SecItemDelete(commonQuery as CFDictionary)
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
    
    /// Triggers event each time the app leaves the background and becomes active.
    /// - note: Useful to use for a refresh logic that can only be performed during the `active` application state.
    /// - note: It doesn't trigger on the app start so preventing excessive updates.
    var didLeaveBackgroundAndBecameActive: Observable<Void> {
        didLeaveBackground.flatMapLatest {
            applicationState
                .filter { $0 == .active }
                .mapToVoid()
                .asSafeSingle()
        }
    }
}

public extension ObservableConvertibleType {
    
    /// Produces duplicate events on app leave background so UI may be reloaded for example.
    @available(iOSApplicationExtension, unavailable)
    func reloadOnLeaveBackground(file: String = #file, function: String = #function, line: UInt = #line) -> Observable<Element> {
        Observable.combineLatest(
            UIApplication.shared.rx
                .didLeaveBackgroundWithTimeInterval
                .startWith(0)
                .doOnNext { timeInterval in
                    if timeInterval > 0 {
                        RoutableLogger.logVerbose("Reloading \(file._fileName):\(line) on leave background", file: file, function: function, line: line)
                    }
                },
            asObservable()
        )
        .map { $1 }
    }
}

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    
    /// Produces duplicate events on app leave background so UI may be reloaded for example.
    @available(iOSApplicationExtension, unavailable)
    func reloadOnLeaveBackground(file: String = #file, function: String = #function, line: UInt = #line) -> Driver<Element> {
        asObservable()
            .reloadOnLeaveBackground(file: file, function: function, line: line)
            .asDriver(onErrorDriveWith: .empty())
    }
}

// ******************************* MARK: - Did move to background

public extension Reactive where Base: UIApplication {
    
    /// Triggers event each time the app moves to the background.
    /// - note: Useful to flush pending data because the app might not have other opportunities.
    /// - note: It doesn't trigger on the app start in the background.
    var didMoveToBackground: Observable<Void> {
        applicationState
            .withRequiredPrevious()
            .filter { (previous: UIApplication.State, current: UIApplication.State) in
                current == UIApplication.State.background
                && previous != UIApplication.State.background
            }
            .mapToVoid()
    }
}

// ******************************* MARK: - Did leave active

public extension Reactive where Base: UIApplication {
    
    /// Triggers event each time the app leaves active state.
    /// - note: Useful to flush pending data because the app might not have other opportunities. It triggers earlier than `didMoveToBackground` so we have more time.
    var didLeaveActive: Observable<Void> {
        applicationState
            .withRequiredPrevious()
            .filter { (previous: UIApplication.State, current: UIApplication.State) in
                current != UIApplication.State.active
                && previous == UIApplication.State.active
            }
            .mapToVoid()
    }
}

// ******************************* MARK: - States

public extension Reactive where Base: UIApplication {
    
    /// Triggers event each time the app enters active state.
    var didBecameActive: Observable<Void> {
        applicationState
            .filter { $0 == .active }
            .mapToVoid()
    }
    
    /// Triggers event each time the app enters inactive state.
    var didBecameInactive: Observable<Void> {
        applicationState
            .filter { $0 == .inactive }
            .mapToVoid()
    }
}
