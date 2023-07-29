//
//  ObservableObserver.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 30.07.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

import RxSwift

public typealias ObservableObserverType = ObservableType & ObserverType

/// Class that is both observable and observer.
public final class ObservableObserver<Element>: ObservableObserverType {
    
    fileprivate let observer: AnyObserver<Element>
    fileprivate let observable: Observable<Element>
    
    public init(observer: AnyObserver<Element>, observable: Observable<Element>) {
        self.observer = observer
        self.observable = observable
    }
    
    // ******************************* MARK: - ObservableType
    
    public func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer: ObserverType, Element == Observer.Element {
        observable.subscribe(observer)
    }
    
    public func asObservable() -> Observable<Element> {
        observable
    }
    
    // ******************************* MARK: - ObserverType
    
    public func on(_ event: Event<Element>) {
        observer.on(event)
    }
    
    public func asObserver() -> AnyObserver<Element> {
        observer
    }
}

// ******************************* MARK: - Extensions

public extension ObservableObserver {
    func accept(_ element: Element) {
        observer.onNext(element)
    }
}

// ******************************* MARK: - Rx

public extension ObservableConvertibleType where Self: ObserverType {
    func asObservableObserver() -> ObservableObserver<Element> {
        ObservableObserver(observer: asObserver(), observable: asObservable())
    }
}
