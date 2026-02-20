//
//  CatchAndComplete.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 27.09.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

import RxSwift

// ******************************* MARK: - Completable

public extension PrimitiveSequence where Trait == RxSwift.CompletableTrait, Element == Never {
    
    /**
     Dismiss errors and complete the sequence instead
     - parameter onError: Additional optional closure to execute on error
     - returns: A completable sequence that never errors and completes when an error occurs in the underlying sequence
     */
    func catchAndComplete(_ onError: ((Error) -> Void)? = nil) -> Completable {
        asObservable()
            .catchAndComplete(onError)
            .asCompletable()
    }
}

// ******************************* MARK: - Maybe

public extension PrimitiveSequence where Trait == MaybeTrait {
    
    /**
     Dismiss errors and complete the sequence instead
     - parameter onError: Additional optional closure to execute on error
     - returns: A maybe sequence that never errors and completes when an error occurs in the underlying sequence
     */
    func catchAndComplete(_ onError: ((Error) -> Void)? = nil) -> Maybe<Element> {
        asObservable()
            .catchAndComplete(onError)
            .asMaybe()
    }
}

// ******************************* MARK: - ObservableConvertibleType

public extension ObservableConvertibleType {
    
    /**
     Dismiss errors and complete the sequence instead
     - parameter onError: Additional optional closure to execute on error
     - returns: An observable sequence that never errors and completes when an error occurs in the underlying sequence
     */
    func catchAndComplete(_ onError: ((Error) -> Void)? = nil) -> Observable<Element> {
        asObservable()
            .catchAndComplete(onError)
    }
}

// ******************************* MARK: - Single

public extension PrimitiveSequence where Trait == SingleTrait {
    
    /**
     Dismiss errors and complete the sequence instead
     - parameter onError: Additional optional closure to execute on error
     - returns: A maybe sequence that never errors and completes when an error occurs in the underlying sequence
     */
    func catchAndComplete(_ onError: ((Error) -> Void)? = nil) -> Maybe<Element> {
        asMaybe()
            .catchAndComplete(onError)
    }
}

// ******************************* MARK: - ObservableType

public extension ObservableType {
    
    /**
     Dismiss errors and complete the sequence instead
     - parameter onError: Additional optional closure to execute on error
     - returns: An observable sequence that never errors and completes when an error occurs in the underlying sequence
     */
    func catchAndComplete(_ onError: ((Error) -> Void)? = nil) -> Observable<Element> {
        `catch` { error in
            onError?(error)
            return Observable.empty()
        }
    }
}
