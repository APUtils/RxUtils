//
//  TimeMeasure.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 29.07.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

// ******************************* MARK: - Completable

public extension PrimitiveSequence where Trait == CompletableTrait, Element == Never {
    
    /// Measures execution time between `onSubscribed` and `onCompleted` events
    func measureExecutionTime(start: (() -> Void)? = nil, end: @escaping (TimeInterval) -> Void) -> Completable {
        asObservable()
            .measureExecutionTime(start: start, end: end)
            .asCompletable()
    }
    
    /// Measures execution time between `onSubscribe` event and the first `onNext` event
    func measureExecutionTimeOnNext(start: (() -> Void)? = nil, end: @escaping (TimeInterval) -> Void) -> Completable {
        asObservable()
            .measureExecutionTimeOnNext(start: start, end: end)
            .asCompletable()
    }
}

// ******************************* MARK: - Maybe

public extension PrimitiveSequence where Trait == MaybeTrait {
    
    /// Measures execution time between `onSubscribed` and `onCompleted` events
    func measureExecutionTime(start: (() -> Void)? = nil, end: @escaping (TimeInterval) -> Void) -> Maybe<Element> {
        asObservable()
            .measureExecutionTime(start: start, end: end)
            .asMaybe()
    }
    
    /// Measures execution time between `onSubscribe` event and the first `onNext` event
    func measureExecutionTimeOnNext(start: (() -> Void)? = nil, end: @escaping (TimeInterval) -> Void) -> Maybe<Element> {
        asObservable()
            .measureExecutionTimeOnNext(start: start, end: end)
            .asMaybe()
    }
}

// ******************************* MARK: - Single

public extension PrimitiveSequence where Trait == SingleTrait {
    
    /// Measures execution time between `onSubscribed` and `onCompleted` events
    func measureExecutionTime(start: (() -> Void)? = nil, end: @escaping (TimeInterval) -> Void) -> Single<Element> {
        asObservable()
            .measureExecutionTime(start: start, end: end)
            .asSingle()
    }
    
    /// Measures execution time between `onSubscribe` event and the first `onNext` event
    func measureExecutionTimeOnNext(start: (() -> Void)? = nil, end: @escaping (TimeInterval) -> Void) -> Single<Element> {
        asObservable()
            .measureExecutionTimeOnNext(start: start, end: end)
            .asSingle()
    }
}

// ******************************* MARK: - ObservableType

public extension ObservableType {
    
    /// Measures execution time between `onSubscribe` and `onCompleted` events
    func measureExecutionTime(start: (() -> Void)? = nil, end: @escaping (TimeInterval) -> Void) -> Observable<Element> {
        var date: Date?
        return self
            .doOnDispose {
                guard let date else { return }
                end(-date.timeIntervalSinceNow)
            }
            .doOnSubscribe {
                date = Date()
                start?()
            }
    }
    
    /// Measures execution time between `onSubscribe` event and the first `onNext` event
    func measureExecutionTimeOnNext(start: (() -> Void)? = nil, end: @escaping (TimeInterval) -> Void) -> Observable<Element> {
        var _date: Date?
        return self
            .doOnNext { _ in
                guard let date = _date else { return }
                end(-date.timeIntervalSinceNow)
                _date = nil
            }
            .doOnSubscribe {
                _date = Date()
                start?()
            }
    }
}
