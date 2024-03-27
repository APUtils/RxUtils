//
//  FilterMany.swift
//  Pods
//
//  Created by Anton Plebanovich on 2.08.23.
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
    
    /**
     Filters each element of an observable collection based on a predicate.
     
     - seealso: [filter operator on reactivex.io](http://reactivex.io/documentation/operators/filter.html)
     
     - parameter predicate: A function to test each element of the source collection.
     - returns: An observable collection that contains elements from the input an original collection that satisfy the condition.
     */
    func filterMany(_ predicate: @escaping (Element.Element) throws -> Bool) -> Maybe<[Element.Element]> {
        asObservable()
            .filterMany(predicate)
            .asMaybe()
    }
}

public extension PrimitiveSequence where Trait == MaybeTrait, Element: OptionalType, Element.Wrapped: Collection {
    
    /**
     Filters each element of an observable collection based on a predicate.
     
     - seealso: [filter operator on reactivex.io](http://reactivex.io/documentation/operators/filter.html)
     
     - parameter predicate: A function to test each element of the source collection.
     - returns: An observable collection that contains elements from the input an original collection that satisfy the condition.
     */
    func filterMany(_ predicate: @escaping (Element.Wrapped.Element) throws -> Bool) -> Maybe<[Element.Wrapped.Element]?> {
        asObservable()
            .filterMany(predicate)
            .asMaybe()
    }
}

// ******************************* MARK: - Single<[Element]>

public extension PrimitiveSequence where Trait == SingleTrait, Element: Collection {
    
    /**
     Filters each element of a single collection based on a predicate.
     
     - seealso: [filter operator on reactivex.io](http://reactivex.io/documentation/operators/filter.html)
     
     - parameter predicate: A function to test each element of the source collection.
     - returns: A single collection that contains elements from the input an original collection that satisfy the condition.
     */
    func filterMany(_ predicate: @escaping (Element.Element) throws -> Bool) -> Single<[Element.Element]> {
        asObservable()
            .filterMany(predicate)
            .asSingle()
    }
}

public extension PrimitiveSequence where Trait == SingleTrait, Element: OptionalType, Element.Wrapped: Collection {
    
    /**
     Filters each element of a single collection based on a predicate.
     
     - seealso: [filter operator on reactivex.io](http://reactivex.io/documentation/operators/filter.html)
     
     - parameter predicate: A function to test each element of the source collection.
     - returns: A single collection that contains elements from the input an original collection that satisfy the condition.
     */
    func filterMany(_ predicate: @escaping (Element.Wrapped.Element) throws -> Bool) -> Single<[Element.Wrapped.Element]?> {
        asObservable()
            .filterMany(predicate)
            .asSingle()
    }
}

// ******************************* MARK: - ObservableType<[Element]>

public extension ObservableType where Element: Collection, Element: Collection {
    
    /**
     Filters each element of an observable collection based on a predicate.
     
     - seealso: [filter operator on reactivex.io](http://reactivex.io/documentation/operators/filter.html)
     
     - parameter predicate: A function to test each element of the source collection.
     - returns: An observable collection that contains elements from the input an original collection that satisfy the condition.
     */
    func filterMany(_ predicate: @escaping (Element.Element) throws -> Bool) -> Observable<[Element.Element]> {
        map { try $0.filter(predicate) }
    }
}

public extension ObservableType where Element: OptionalType, Element.Wrapped: Collection {
    
    /**
     Filters each element of an observable collection based on a predicate.
     
     - seealso: [filter operator on reactivex.io](http://reactivex.io/documentation/operators/filter.html)
     
     - parameter predicate: A function to test each element of the source collection.
     - returns: An observable collection that contains elements from the input an original collection that satisfy the condition.
     */
    func filterMany(_ predicate: @escaping (Element.Wrapped.Element) throws -> Bool) -> Observable<[Element.Wrapped.Element]?> {
        map { try $0.value?.filter(predicate) }
    }
}
