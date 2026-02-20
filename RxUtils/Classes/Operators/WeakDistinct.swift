//
//  WeakDistinct.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 8.09.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

// ******************************* MARK: - Maybe

public extension PrimitiveSequence where Trait == MaybeTrait, Element: AnyObject & Hashable {
    
    func distinctWeakly() -> Maybe<Element> {
        asObservable()
            .distinctWeakly()
            .asMaybe()
    }
}

public extension PrimitiveSequence where Trait == MaybeTrait, Element: AnyObject & Equatable {
    
    func distinctUntilChangedWeakly() -> Maybe<Element> {
        asObservable()
            .distinctUntilChangedWeakly()
            .asMaybe()
    }
}

// ******************************* MARK: - Single

public extension PrimitiveSequence where Trait == SingleTrait, Element: AnyObject & Hashable {
    
    func distinctWeakly() -> Single<Element> {
        asObservable()
            .distinctWeakly()
            .asSingle()
    }
}

public extension PrimitiveSequence where Trait == SingleTrait, Element: AnyObject & Equatable {
    
    func distinctUntilChangedWeakly() -> Single<Element> {
        asObservable()
            .distinctUntilChangedWeakly()
            .asSingle()
    }
}

// ******************************* MARK: - ObservableType

public extension ObservableType where Element: AnyObject & Hashable {
    
    /**
     Suppress duplicate items emitted by an Observable
     It do not capture previous element strongly to prevent unexpected leaks.     
     - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
     - returns: An observable sequence only containing the distinct contiguous elements, based on equality operator, from the source sequence.
     */
    func distinctWeakly() -> Observable<Element> {
        let cache = NSHashTable<Element>(options: .weakMemory)
        return flatMap { element -> Observable<Element> in
            if cache.contains(element) {
                return Observable<Element>.empty()
            } else {
                cache.add(element)
                return Observable<Element>.just(element)
            }
        }
    }
}

public extension ObservableType where Element: AnyObject & Equatable {
    
    /**
     Returns an observable sequence that contains only distinct contiguous elements according to equality operator.
     It do not capture previous element strongly to prevent unexpected leaks.
     - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
     - returns: An observable sequence only containing the distinct contiguous elements, based on equality operator, from the source sequence.
     */
    func distinctUntilChangedWeakly() -> Observable<Element> {
        weak var cachedElement: Element?
        return flatMap { element -> Observable<Element> in
            if cachedElement == element {
                return Observable<Element>.empty()
            } else {
                cachedElement = element
                return Observable<Element>.just(element)
            }
        }
    }
}
