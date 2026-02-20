//
//  SortMany.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 6.08.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

#if SPM
import APExtensionsDispatch
import APExtensionsOccupiable
import APExtensionsOptionalType
#else
import APExtensions
#endif
import RxSwift

// ******************************* MARK: - Maybe<[Element]>

public extension PrimitiveSequence where Trait == MaybeTrait, Element: Collection {
    
    /// Sorts each element of an observable collection based on a `areInIncreasingOrder` closure.
    /// - parameter areInIncreasingOrder: A closure to test each element of the source collection.
    func sortMany(by areInIncreasingOrder: @escaping (Element.Element, Element.Element) throws -> Bool) -> Maybe<[Element.Element]> {
        asObservable()
            .sortMany(areInIncreasingOrder)
            .asMaybe()
    }
}

public extension PrimitiveSequence where Trait == MaybeTrait, Element: OptionalType, Element.Wrapped: Collection {
    
    /// Sorts each element of an observable collection based on a `areInIncreasingOrder` closure.
    /// - parameter areInIncreasingOrder: A closure to test each element of the source collection.
    func sortMany(by areInIncreasingOrder: @escaping (Element.Wrapped.Element, Element.Wrapped.Element) throws -> Bool) -> Maybe<[Element.Wrapped.Element]?> {
        asObservable()
            .sortMany(areInIncreasingOrder)
            .asMaybe()
    }
}

// ******************************* MARK: - Single<[Element]>

public extension PrimitiveSequence where Trait == SingleTrait, Element: Collection {
    
    /// Sorts each element of an observable collection based on a `areInIncreasingOrder` closure.
    /// - parameter areInIncreasingOrder: A closure to test each element of the source collection.
    func sortMany(by areInIncreasingOrder: @escaping (Element.Element, Element.Element) throws -> Bool) -> Single<[Element.Element]> {
        asObservable()
            .sortMany(areInIncreasingOrder)
            .asSingle()
    }
}

public extension PrimitiveSequence where Trait == SingleTrait, Element: OptionalType, Element.Wrapped: Collection {
    
    /// Sorts each element of an observable collection based on a `areInIncreasingOrder` closure.
    /// - parameter areInIncreasingOrder: A closure to test each element of the source collection.
    func sortMany(by areInIncreasingOrder: @escaping (Element.Wrapped.Element, Element.Wrapped.Element) throws -> Bool) -> Single<[Element.Wrapped.Element]?> {
        asObservable()
            .sortMany(areInIncreasingOrder)
            .asSingle()
    }
}

// ******************************* MARK: - ObservableType<[Element]>

public extension ObservableType where Element: Collection, Element: Collection {
    
    /// Sorts each element of an observable collection based on a `areInIncreasingOrder` closure.
    /// - parameter areInIncreasingOrder: A closure to test each element of the source collection.
    func sortMany(_ areInIncreasingOrder: @escaping (Element.Element, Element.Element) throws -> Bool) -> Observable<[Element.Element]> {
        map { try $0.sorted(by: areInIncreasingOrder) }
    }
}

public extension ObservableType where Element: OptionalType, Element.Wrapped: Collection {
    
    /// Sorts each element of an observable collection based on a `areInIncreasingOrder` closure.
    /// - parameter areInIncreasingOrder: A closure to test each element of the source collection.
    func sortMany(_ areInIncreasingOrder: @escaping (Element.Wrapped.Element, Element.Wrapped.Element) throws -> Bool) -> Observable<[Element.Wrapped.Element]?> {
        map { try $0.value?.sorted(by: areInIncreasingOrder) }
    }
}
