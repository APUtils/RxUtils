//
//  RxSwift+UIAlertController.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 2.10.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import RxSwift
import UIKit

// ******************************* MARK: - Single

@available(iOSApplicationExtension, unavailable)
public extension PrimitiveSequence where Trait == SingleTrait {
    
    /// Shows a notification alert which will pause element processing until OK button is pressed.
    /// - parameter title: Alert title. Default is `nil` - no title.
    /// - parameter message: Alert message.
    /// - parameter ok: OK action.
    /// - note: Subscription is happening on the main thread. 
    func showOkAlert(title: String? = nil,
                     message: String?,
                     ok: UIAlertController.Action = UIAlertController.Action(title: "OK", style: .default)) -> Single<Element> {
        
        asObservable()
            .showOkAlert(title: title, message: message, ok: ok)
            .asSingle()
    }
    
    /// Shows ask for continue alert with title, message, continue title, cancel title.
    /// An event is paused until continue button is pressed.
    /// An event is filtered if cancel button is pressed.
    /// - parameter title: Alert title. Default is `nil` - no title.
    /// - parameter message: Alert message. Default is `nil` - no message.
    /// - parameter continue: Continue action.
    /// - parameter cancel: Cancel action.
    /// - note: Subscription is happening on the main thread.
    func showContinueAlert(title: String? = nil,
                           message: String?,
                           continue: UIAlertController.Action = UIAlertController.Action(title: "Continue", style: .default),
                           cancel: UIAlertController.Action = UIAlertController.Action(title: "Cancel", style: .cancel)) -> Single<Element> {
        
        asObservable()
            .showContinueAlert(title: title, message: message, continue: `continue`, cancel: cancel)
            .asSingle()
    }
}

// ******************************* MARK: - Completable

@available(iOSApplicationExtension, unavailable)
public extension PrimitiveSequence where Trait == CompletableTrait, Element == Never {
    
    /// Shows a notification alert which will pause element processing until OK button is pressed.
    /// - parameter title: Alert title. Default is `nil` - no title.
    /// - parameter message: Alert message.
    /// - parameter ok: OK action.
    /// - note: Subscription is happening on the main thread.
    func showOkAlert(title: String? = nil,
                     message: String?,
                     ok: UIAlertController.Action = UIAlertController.Action(title: "OK", style: .default)) -> Completable {
        
        asObservable()
            .showOkAlert(title: title, message: message, ok: ok)
            .asCompletable()
    }
    
    /// Shows ask for continue alert with title, message, continue title, cancel title.
    /// An event is paused until continue button is pressed.
    /// An event is filtered if cancel button is pressed.
    /// - parameter title: Alert title. Default is `nil` - no title.
    /// - parameter message: Alert message. Default is `nil` - no message.
    /// - parameter continue: Continue action.
    /// - parameter cancel: Cancel action.
    /// - note: Subscription is happening on the main thread.
    func showContinueAlert(title: String? = nil,
                           message: String?,
                           continue: UIAlertController.Action = UIAlertController.Action(title: "Continue", style: .default),
                           cancel: UIAlertController.Action = UIAlertController.Action(title: "Cancel", style: .cancel)) -> Completable {
        
        asObservable()
            .showContinueAlert(title: title, message: message, continue: `continue`, cancel: cancel)
            .asCompletable()
    }
}

// ******************************* MARK: - ObservableConvertibleType

@available(iOSApplicationExtension, unavailable)
public extension ObservableConvertibleType {
    
    /// Shows a notification alert which will pause element processing until OK button is pressed.
    /// - parameter title: Alert title. Default is `nil` - no title.
    /// - parameter message: Alert message.
    /// - parameter ok: OK action.
    /// - note: Subscription is happening on the main thread.
    func showOkAlert(title: String? = nil,
                     message: String?,
                     ok: UIAlertController.Action = UIAlertController.Action(title: "OK", style: .default)) -> Observable<Element> {
        
        return flatMapAlert(title: title, message: message, actions: [ok]) { element, action in
            return .just(element)
        }
    }
    
    /// Shows ask for continue alert with title, message, continue title, cancel title.
    /// An event is paused until continue button is pressed.
    /// An event is filtered if cancel button is pressed.
    /// - parameter title: Alert title. Default is `nil` - no title.
    /// - parameter message: Alert message. Default is `nil` - no message.
    /// - parameter continue: Continue action.
    /// - parameter cancel: Cancel action.
    /// - note: Subscription is happening on the main thread.
    func showContinueAlert(title: String? = nil,
                           message: String?,
                           continue: UIAlertController.Action = UIAlertController.Action(title: "Continue", style: .default),
                           cancel: UIAlertController.Action = UIAlertController.Action(title: "Cancel", style: .cancel)) -> Observable<Element> {
        
        return flatMapAlert(title: title, message: message, actions: [`continue`, cancel]) { element, action in
            if action == `continue` {
                return .just(element)
            } else {
                return .empty()
            }
        }
    }
    
    /// Presents an alert for each reeived element and allows to perform a flat map operation on
    /// received element and performed action.
    /// - parameter title: Alert title.
    /// - parameter message: Alert message.
    /// - parameter actions: Alert actions to show.
    /// - note: Subscription is happening on the main thread.
    func flatMapAlert<Result>(title: String?,
                              message: String?,
                              actions: [UIAlertController.Action],
                              _ selector: @escaping (Element, UIAlertController.Action) -> Observable<Result>) -> Observable<Result> {
        
        return asObservable()
            .flatMap { element in
                return UIAlertController.rx
                    .show(title: title, message: message, actions: actions)
                    .flatMapObservable { action in selector(element, action) }
            }
    }
}

// ******************************* MARK: - AlertController

@available(iOSApplicationExtension, unavailable)
public extension UIAlertController {
    struct Action: Equatable {
        public let title: String
        public let style: UIAlertAction.Style
        
        public init(title: String, style: UIAlertAction.Style) {
            self.title = title
            self.style = style
        }
    }
    
    func add(action: Action, handler: @escaping () -> Void) {
        addAction(UIAlertAction(title: action.title, style: action.style, handler: { _ in
            handler()
        }))
    }
}

@available(iOSApplicationExtension, unavailable)
public extension Reactive where Base: UIAlertController {
    
    /// Shows an alert in a separate window.
    /// - note: Subscription is happening on the main thread.
    static func show(title: String?,
                     message: String?,
                     actions: [UIAlertController.Action]) -> Single<UIAlertController.Action> {
        
        Single<UIAlertController.Action>
            .create(subscribe: { observer in
                let alertVC = AlertController(title: title, message: message, preferredStyle: .alert)
                
                actions.forEach { action in
                    alertVC.add(action: action, handler: {
                        observer(.success(action))
                    })
                }
                
                alertVC.present(animated: true) { error in
                    if let error = error {
                        observer(.failure(error))
                    }
                }
                
                return Disposables.create {
                    alertVC.dismiss(animated: true, completion: nil)
                }
            })
            .subscribe(on: ConcurrentMainScheduler.instance)
    }
    
    /// Shows a picker alert in a separate window.
    /// - note: Subscription is happening on the main thread.
    static func showPicker(title: String?,
                           message: String?,
                           cancelTitle: String?,
                           actionTitles: [String]) -> Maybe<(Int, String)> {
        
        Maybe.create(subscribe: { observer in
            let alertVC = AlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            alertVC.add(action: .init(title: cancelTitle ?? "Cancel", style: .cancel)) {
                observer(.completed)
            }
            
            actionTitles.enumerated().forEach { index, actionTitle in
                alertVC.add(action: .init(title: actionTitle, style: .default), handler: {
                    observer(.success((index, actionTitle)))
                })
            }
            
            alertVC.present(animated: true) { error in
                if let error = error {
                    observer(.error(error))
                }
            }
            
            return Disposables.create {
                alertVC.dismiss(animated: true, completion: nil)
            }
        })
        .subscribe(on: ConcurrentMainScheduler.instance)
    }
}

@available(iOSApplicationExtension, unavailable)
private final class AlertController: UIAlertController {
    
    private lazy var alertWindow: UIWindow? = {
        let window: UIWindow
        if #available(iOS 13.0, *), let windowScene = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first {
            window = UIWindow(windowScene: windowScene)
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        
        window.windowLevel = .alert
        window.rootViewController = AppearanceCaptureViewController()
        
        return window
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        view.removeFromSuperview()
        
        alertWindow?.rootViewController?.view.removeFromSuperview()
        alertWindow?.rootViewController = nil
        alertWindow?.isHidden = true
        
        // https://stackoverflow.com/a/59988501/4124265
        if #available(iOS 13.0, *) {
            alertWindow?.windowScene = nil
        }
        
        alertWindow = nil
    }
    
    func present(animated: Bool = true, completion: ((Error?) -> Void)? = nil) {
        g_performInMain { [self] in
            guard let alertWindow = alertWindow,
                  let rootViewController = alertWindow.rootViewController else {
                      
                      completion?(NSError(domain: "AlertController.present", code: -1, userInfo: nil))
                      return
                  }
            
            alertWindow.makeKeyAndVisible()
            rootViewController.present(self, animated: animated, completion: {
                completion?(nil)
            })
        }
    }
}

// ******************************* MARK: - AppearanceCaptureViewController

@available(iOSApplicationExtension, unavailable)
private final class AppearanceCaptureViewController: UIViewController {
    private var customPreferredStatusBarStyle = UIStatusBarStyle.lightContent
    private var customPrefersStatusBarHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return customPrefersStatusBarHidden
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return customPreferredStatusBarStyle
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        onInitSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        onInitSetup()
    }
    
    private func onInitSetup() {
        let topVc = g_statusBarStyleTopViewController
        
        customPrefersStatusBarHidden = topVc?.prefersStatusBarHidden ?? false
        
        if (Bundle.main.object(forInfoDictionaryKey: "UIViewControllerBasedStatusBarAppearance") as! Bool?) ?? true {
            customPreferredStatusBarStyle = topVc?.preferredStatusBarStyle ?? .default
        } else {
            if let barStyle = topVc?.navigationController?.navigationBar.barStyle {
                customPreferredStatusBarStyle = barStyle == .black ? .lightContent : .default
            }
        }
    }
}

// ******************************* MARK: - Private Functions

/// Returns top most view controller that handles status bar style.
/// This property might be more accurate than `topViewController` if custom container view controllers configured properly to return their top most controllers for status bar appearance.
@available(iOSApplicationExtension, unavailable)
private var g_statusBarStyleTopViewController: UIViewController? {
    var currentVc = g_topViewController()
    while let newTopVc = currentVc?.childForStatusBarStyle {
        currentVc = g_topViewController(base: newTopVc)
    }
    
    return currentVc
}

/// Returns top view controller from `base` controller.
/// - note: In case you are using custom container controllers in your application this method won't be able to process them.
/// - parameters:
///   - base: Base controller from which to start. If not specified or nil then application delegate window's rootViewController will be used.
///   - shouldCheckPresented: Should it check for presented controllers?
@available(iOSApplicationExtension, unavailable)
private func g_topViewController(base: UIViewController? = nil, shouldCheckPresented: Bool = true) -> UIViewController? {
    let base = base ?? UIApplication.shared.delegate?.window??.rootViewController
    
    if let navigationVc = base as? UINavigationController {
        return g_topViewController(base: navigationVc.topViewController, shouldCheckPresented: shouldCheckPresented)
    }
    
    if let tabBarVc = base as? UITabBarController {
        if let selected = tabBarVc.selectedViewController {
            return g_topViewController(base: selected, shouldCheckPresented: shouldCheckPresented)
        }
    }
    
    if shouldCheckPresented, let presented = base?.presentedViewController {
        return g_topViewController(base: presented, shouldCheckPresented: shouldCheckPresented)
    }
    
    return base
}

private func g_performInMain(_ closure: @escaping () -> Void) {
    if Thread.isMainThread {
        closure()
    } else {
        DispatchQueue.main.async { closure() }
    }
}
