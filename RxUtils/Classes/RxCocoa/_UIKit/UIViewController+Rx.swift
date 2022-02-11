//
//  UIViewController+Rx.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 12/4/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

// ******************************* MARK: - View State

public extension Reactive where Base: UIViewController {
    
    /// Reactive wrapper for `viewDidLoad` method invoke.
    var viewDidLoad: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidLoad))
            .mapToVoid()
    }
    
    /// Reactive wrapper for `viewWillLayoutSubviews` method invoke.
    var viewWillLayoutSubviews: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewWillLayoutSubviews))
            .mapToVoid()
    }
    
    /// Reactive wrapper for `viewDidLayoutSubviews` method invoke.
    var viewDidLayoutSubviews: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .mapToVoid()
    }
    
    /// Reactive wrapper for `viewWillAppear(_:)` method invoke. Pass `animated` parameter as element.
    var viewWillAppear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
            .map { $0.first as? Bool ?? false }
    }
    
    /// Reactive wrapper for `viewDidAppear(_:)` method invoke. Pass `animated` parameter as element.
    var viewDidAppear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewDidAppear(_:)))
            .map { $0.first as? Bool ?? false }
    }
    
    /// Reactive wrapper for `viewWillDisappear(_:)` method invoke. Pass `animated` parameter as element.
    var viewWillDisappear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillDisappear(_:)))
            .map { $0.first as? Bool ?? false }
    }
    
    /// Reactive wrapper for `viewDidDisappear(_:)` method invoke. Pass `animated` parameter as element.
    var viewDidDisappear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewDidDisappear(_:)))
            .map { $0.first as? Bool ?? false }
    }
}

// ******************************* MARK: - Presentation

public extension Reactive where Base: UIViewController {
    
    /// Present controller in the main thread
    func present(_ vc: UIViewController, animated: Bool = true) -> Completable {
        Completable
            .create { observer in
                base.present(vc, animated: animated) {
                    observer(.completed)
                }
                
                return Disposables.create()
            }
            .subscribe(on: MainScheduler.instance)
    }
}
