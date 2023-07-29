//
//  UIView+Rx.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 9.10.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

public extension Reactive where Base: UIView {
    /// Reactive wrapper for `load(_:)`
    var tintColor: Binder<UIColor> {
        return Binder(base, binding: { (view, tintColor) -> Void in
            view.tintColor = tintColor
        })
    }
    
    /// Reactive wrapper for bounds
    var bounds: ControlProperty<CGRect> {
        let values = methodInvoked(#selector(setter: UIView.bounds))
            .flatMap { [weak base] _ -> Observable<CGRect> in
                guard let base = base else { return .empty() }
                return .just(base.bounds)
            }
            .startWithDeferred { [weak base] in base?.bounds }
            .distinctUntilChanged()
        
        let bindingObserver = Binder(base) { view, bounds in
            view.bounds = bounds
        }
        
        return ControlProperty(values: values, valueSink: bindingObserver)
    }
}
