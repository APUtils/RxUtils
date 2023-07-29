//
//  TimeMeasure.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 29.07.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

import RxSwift

// ******************************* MARK: - Completable

public extension PrimitiveSequence where Trait == CompletableTrait, Element == Never {
    
    /// Measures execution time between `onSubscribed` and `onCompleted` events
    func measureExecutionTime(_ closure: @escaping (TimeInterval) -> Void) -> Completable {
        asObservable()
            .measureExecutionTime(closure)
            .asCompletable()
    }
}

// ******************************* MARK: - Maybe

public extension PrimitiveSequence where Trait == MaybeTrait {
    
    /// Measures execution time between `onSubscribed` and `onCompleted` events
    func measureExecutionTime(_ closure: @escaping (TimeInterval) -> Void) -> Maybe<Element> {
        asObservable()
            .measureExecutionTime(closure)
            .asMaybe()
    }
}

// ******************************* MARK: - Single

public extension PrimitiveSequence where Trait == SingleTrait {
    
    /// Measures execution time between `onSubscribed` and `onCompleted` events
    func measureExecutionTime(_ closure: @escaping (TimeInterval) -> Void) -> Single<Element> {
        asObservable()
            .measureExecutionTime(closure)
            .asSingle()
    }
}

// ******************************* MARK: - ObservableType

public extension ObservableType {
    
    /// Measures execution time between `onSubscribe` and `onCompleted` events
    func measureExecutionTime(_ closure: @escaping (TimeInterval) -> Void) -> Observable<Element> {
        var date: Date?
        return self
            .doOnDispose {
                guard let date else { return }
                closure(-date.timeIntervalSinceNow)
            }
            .doOnSubscribe { date = Date() }
    }
}
