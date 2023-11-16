//
//  CatchJustComplete.swift
//  Pods
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
    func catchJustComplete(_ onError: ((Error) -> Void)? = nil) -> Completable {
        asObservable()
            .catchJustComplete(onError)
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
    func catchJustComplete(_ onError: ((Error) -> Void)? = nil) -> Maybe<Element> {
        asObservable()
            .catchJustComplete(onError)
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
    func catchJustComplete(_ onError: ((Error) -> Void)? = nil) -> Observable<Element> {
        asObservable()
            .catchJustComplete(onError)
    }
}

// ******************************* MARK: - Single

public extension PrimitiveSequence where Trait == SingleTrait {
    
    /**
     Dismiss errors and complete the sequence instead
     - parameter onError: Additional optional closure to execute on error
     - returns: A maybe sequence that never errors and completes when an error occurs in the underlying sequence
     */
    func catchJustComplete(_ onError: ((Error) -> Void)? = nil) -> Maybe<Element> {
        asMaybe()
            .catchJustComplete(onError)
    }
}

// ******************************* MARK: - ObservableType

public extension ObservableType {
    
    /**
     Dismiss errors and complete the sequence instead
     - parameter onError: Additional optional closure to execute on error
     - returns: An observable sequence that never errors and completes when an error occurs in the underlying sequence
     */
    func catchJustComplete(_ onError: ((Error) -> Void)? = nil) -> Observable<Element> {
        `catch` { error in
            onError?(error)
            return Observable.empty()
        }
    }
}
