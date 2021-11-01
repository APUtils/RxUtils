//
//  RxSwift+Operators+Single.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 12/5/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional
import RxSwiftExt

// ******************************* MARK: - Single

public extension PrimitiveSequence where Trait == SingleTrait {
    
    /// Projects each element of an observable sequence into Void
    func mapToVoid() -> Single<Void> {
        return map { _ in () }
    }
    
    /// Creates sequence that can not be disposed
    func preventDisposal() -> Single<Element> {
        return .create { observer in
            let lock = NSLock()
            var observer: ((Result<Element, Error>) -> Void)? = observer
            _ = self.subscribe { event in
                lock.lock(); defer { lock.unlock() }
                observer?(event)
            }
            
            return Disposables.create {
                lock.lock(); defer { lock.unlock() }
                observer = nil
            }
        }
    }
    
    /// Wraps element into optional
    func wrapIntoOptional() -> Single<Element?> {
        return map { $0 }
    }
    
    /**
     Pauses the elements of the source single sequence based on the latest element from the second observable sequence.
     
     While paused, elements from the source are buffered, limited to a single element.
     
     When resumed, the buffered element, if present, is flushed.
     
     - seealso: [pausable operator on reactivex.io](http://reactivex.io/documentation/operators/backpressure.html)
     
     - parameter pauser: The observable sequence used to pause the source observable sequence.
     - returns: The single sequence which is paused and resumed based upon the pauser observable sequence.
     */
    func pausableBuffered<Pauser: ObservableType>(_ pauser: Pauser) -> Single<Element> where Pauser.Element == Bool {
        asObservable()
            .pausableBuffered(pauser)
            .asSingle()
    }
}

// ******************************* MARK: - Single<Collection>

public extension PrimitiveSequence where Trait == SingleTrait, Element: Collection {
    
    /**
     Filters each element of a single collection based on a predicate.
     
     - seealso: [filter operator on reactivex.io](http://reactivex.io/documentation/operators/filter.html)
     
     - parameter predicate: A function to test each element of the source collection.
     - returns: A single collection that contains elements from the input an original collection that satisfy the condition.
     */
    func filterMany(_ predicate: @escaping (Element.Element) throws -> Bool) -> Single<[Element.Element]> {
        map { try $0.filter(predicate) }
    }
    
    /**
     Projects each element of a single collection into a new form.
     
     - parameter transform: A transform function to apply to each element of the source collection.
     - returns: A single collection whose elements are the result of invoking the transform function on each element of source.
     */
    func mapMany<Result>(_ transform: @escaping (Element.Element) throws -> Result) -> Single<[Result]> {
        return map { collection -> [Result] in
            try collection.map(transform)
        }
    }
}

// ******************************* MARK: - Single of optional element

public extension PrimitiveSequence where Trait == SingleTrait, Element: OptionalType {
    
    /**
     Unwraps and filters out `nil` elements.
     
     - returns: `Maybe` of source `Single`'s elements, with `nil` elements filtered out.
     */
    func filterNil() -> Maybe<Element.Wrapped> {
        asObservable().filterNil().asMaybe()
    }
}
