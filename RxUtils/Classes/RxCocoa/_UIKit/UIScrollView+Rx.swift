//
//  UIScrollView+Rx.swift
//  Pods
//
//  Created by Anton Plebanovich on 9.10.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

public extension Reactive where Base: UIScrollView {
    
    /// Reactive wrapper for contentInset
    var contentInset: ControlProperty<UIEdgeInsets> {
        let values = methodInvoked(#selector(setter: UIScrollView.contentInset))
            .flatMap { [weak base] _ -> Observable<UIEdgeInsets> in
                guard let base = base else { return .empty() }
                return .just(base.contentInset)
            }
            .startWithDeferred { [weak base] in base?.contentInset }
            .distinctUntilChanged()
        
        let bindingObserver = Binder(base) { scrollView, contentInset in
            scrollView.contentInset = contentInset
        }
        
        return ControlProperty(values: values, valueSink: bindingObserver)
    }
    
    /// Reactive wrapper for contentSize
    var contentSize: ControlProperty<CGSize> {
        let values = methodInvoked(#selector(setter: UIScrollView.contentSize))
            .flatMap { [weak base] _ -> Observable<CGSize> in
                guard let base = base else { return .empty() }
                return .just(base.contentSize)
            }
            .startWithDeferred { [weak base] in base?.contentSize }
            .distinctUntilChanged()
        
        let bindingObserver = Binder(base) { scrollView, contentSize in
            scrollView.contentSize = contentSize
        }
        
        return ControlProperty(values: values, valueSink: bindingObserver)
    }
    
    /// Reactive wrapper for page size. Starts with current page size.
    var pageSize: Observable<CGFloat> {
        return bounds
            .map { $0.width }
            .distinctUntilChanged()
    }
    
    /// Reactive wrapper for page. Starts with current page number.
    var currentPage: Observable<Int> {
        return Observable.merge(contentInset.mapToVoid(), pageSize.mapToVoid(), contentOffset.mapToVoid())
            .flatMap { [weak base] _ -> Observable<Int> in
                guard let base = base else { return .empty() }
                return .just(base.currentPage)
            }
            .startWithDeferred { [weak base] in base?.currentPage }
            .distinctUntilChanged()
    }
    
    /// Reactive wrapper for pages. Starts with current pages number.
    var numberOfPages: Observable<Int> {
        return Observable.merge(contentInset.mapToVoid(), pageSize.mapToVoid(), contentSize.mapToVoid())
            .flatMap { [weak base] _ -> Observable<Int> in
                guard let base = base else { return .empty() }
                return .just(base.numberOfPages)
            }
            .startWithDeferred { [weak base] in base?.numberOfPages }
            .distinctUntilChanged()
    }
}

// ******************************* MARK: - Private Extensions

fileprivate extension UIScrollView {
    /// Current page size
    var pageSize: CGFloat {
        return bounds.width
    }
    
    /// Current page value
    var currentPage: Int {
        let currentPageFloat = (contentOffset.x + contentInset.left) / pageSize
        let currentPage = Int(currentPageFloat.rounded())
        return currentPage
    }
    
    /// Current number of pages
    var numberOfPages: Int {
        let numberOfPagesFloat = (contentSize.width + contentInset.right + contentInset.left) / pageSize
        let numberOfPages = Int(numberOfPagesFloat.rounded())
        return numberOfPages
    }
}
