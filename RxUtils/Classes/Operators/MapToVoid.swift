//
//  MapToVoid.swift
//  Pods
//
//  Created by Anton Plebanovich on 3.08.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RoutableLogger

// ******************************* MARK: - Maybe

public extension PrimitiveSequence where Trait == MaybeTrait {
    
    /// Projects each element of an observable sequence into Void
    func mapToVoid() -> Maybe<Void> {
        asObservable()
            .mapToVoid()
            .asMaybe()
    }
}

public extension PrimitiveSequence where Trait == MaybeTrait, Element == Void {
    
    /// Projects each element of an observable sequence into Void
    @available(*, deprecated, message: "`mapToVoid()` operator is used on already `Void` sequence")
    func mapToVoid(file: String = #file, function: String = #function, line: UInt = #line) -> Maybe<Element> {
        RoutableLogger.logError("`mapToVoid()` operator is used on already `Void` sequence", file: file, function: function, line: line)
        return self
    }
}

// ******************************* MARK: - Single

public extension PrimitiveSequence where Trait == SingleTrait {
    
    /// Projects each element of an observable sequence into Void
    func mapToVoid() -> Single<Void> {
        asObservable()
            .mapToVoid()
            .asSingle()
    }
}

public extension PrimitiveSequence where Trait == SingleTrait, Element == Void {
    
    /// Projects each element of an observable sequence into Void
    @available(*, deprecated, message: "`mapToVoid()` operator is used on already `Void` sequence")
    func mapToVoid(file: String = #file, function: String = #function, line: UInt = #line) -> Single<Void> {
        RoutableLogger.logError("`mapToVoid()` operator is used on already `Void` sequence", file: file, function: function, line: line)
        return self
    }
}

// ******************************* MARK: - Signal

public extension SharedSequenceConvertibleType where SharingStrategy == SignalSharingStrategy {
    
    /// Projects each element of an signal sequence into Void
    func mapToVoid() -> Signal<Void> {
        asObservable()
            .mapToVoid()
            .asSignal(onErrorSignalWith: .empty())
    }
}

public extension SharedSequenceConvertibleType where SharingStrategy == SignalSharingStrategy, Element == Void {
    
    /// Projects each element of an signal sequence into Void
    @available(*, deprecated, message: "`mapToVoid()` operator is used on already `Void` sequence")
    func mapToVoid(file: String = #file, function: String = #function, line: UInt = #line) -> Signal<Void> {
        RoutableLogger.logError("`mapToVoid()` operator is used on already `Void` sequence", file: file, function: function, line: line)
        return asSignal()
    }
}

// ******************************* MARK: - ObservableType

public extension ObservableType {
    
    /// Projects each element of an observable sequence into Void
    func mapToVoid() -> Observable<Void> {
        map { _ in () }
    }
}

public extension ObservableType where Element == Void {
    
    /// Projects each element of an observable sequence into Void
    @available(*, deprecated, message: "`mapToVoid()` operator is used on already `Void` sequence")
    func mapToVoid(file: String = #file, function: String = #function, line: UInt = #line) -> Observable<Element> {
        RoutableLogger.logError("`mapToVoid()` operator is used on already `Void` sequence", file: file, function: function, line: line)
        return asObservable()
    }
}
