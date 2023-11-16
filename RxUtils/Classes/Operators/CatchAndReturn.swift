//
//  CatchAndReturn.swift
//  Pods
//
//  Created by Anton Plebanovich on 16.11.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

import RxSwift

// ******************************* MARK: - Maybe

public extension PrimitiveSequence where Trait == MaybeTrait {
    
    /**
     Continues an observable sequence that is terminated by an error with a single element.
     - parameter onError: Closure that takes an error and returns an element to use in the sequence.
     - returns: An sequence containing the source sequence's elements, followed by the `element` in case an error occurred.
     */
    func catchAndReturn(_ onError: @escaping (Error) throws -> Element) -> Maybe<Element> {
        asObservable()
            .catchAndReturn(onError)
            .asMaybe()
    }
}

// ******************************* MARK: - ObservableConvertibleType

public extension ObservableConvertibleType {
    
    /**
     Continues an observable sequence that is terminated by an error with a single element.
     - parameter onError: Closure that takes an error and returns an element to use in the sequence.
     - returns: An sequence containing the source sequence's elements, followed by the `element` in case an error occurred.
     */
    func catchAndReturn(_ onError: @escaping (Error) throws -> Element) -> Observable<Element> {
        asObservable()
            .catchAndReturn(onError)
    }
}

// ******************************* MARK: - Single

public extension PrimitiveSequence where Trait == SingleTrait {
    
    /**
     Continues an observable sequence that is terminated by an error with a single element.
     - parameter onError: Closure that takes an error and returns an element to use in the sequence.
     - returns: An sequence containing the source sequence's elements, followed by the `element` in case an error occurred.
     */
    func catchAndReturn(_ onError: @escaping (Error) throws -> Element) -> Single<Element> {
        asObservable()
            .catchAndReturn(onError)
            .asSingle()
    }
}

// ******************************* MARK: - ObservableType

public extension ObservableType {
    
    /**
     Continues an observable sequence that is terminated by an error with a single element.
     - parameter onError: Closure that takes an error and returns an element to use in the sequence.     
     - returns: An sequence containing the source sequence's elements, followed by the `element` in case an error occurred.
     */
    func catchAndReturn(_ onError: @escaping (Error) throws -> Element) -> Observable<Element> {
        `catch` { error in
            let element = try onError(error)
            return Observable.just(element)
        }
    }
}
