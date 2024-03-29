//
//  RxSwift+Operators+Maybe.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 2/27/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

// ******************************* MARK: - Maybe

public extension PrimitiveSequence where Trait == MaybeTrait {
    
    /// Converts `self` to `Completable` trait, ignoring its emitted value if
    /// one exists.
    ///
    /// - returns: Completable trait that represents `self`.
    func asCompletable() -> Completable {
        asObservable().ignoreElements().asCompletable()
    }
    
    /// Projects each element of an observable sequence into Any
    func mapToAny() -> Maybe<Any> {
        return map { $0 }
    }
    
    /// Creates sequence that can not be disposed.
    /// - parameter disposeBag: Optional dispose bag that will be used to perform long-lasted subscription. 
    /// - note: Please keep in mind that subscription is not disposed if sequence never ends.
    /// This may lead to infinite memory grow.
    func preventDisposal(disposeBag: DisposeBag? = nil) -> Maybe<Element> {
        return .create { observer in
            let recursiveLock = NSRecursiveLock()
            var observer: ((MaybeEvent<Element>) -> Void)? = observer
            
            let disposable = self.subscribe { event in
                recursiveLock.lock(); defer { recursiveLock.unlock() }
                observer?(event)
            }
            
            if let disposeBag = disposeBag {
                disposeBag.insert(disposable)
            }
            
            return Disposables.create {
                recursiveLock.lock(); defer { recursiveLock.unlock() }
                observer = nil
            }
        }
    }
    
    /// Wraps element into optional
    func wrapIntoOptional() -> Maybe<Element?> {
        return map { $0 }
    }
    
    /**
     Projects each element of an observable sequence to an observable sequence and merges the resulting observable sequences into one observable sequence.
     
     - seealso: [flatMap operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
     
     - parameter selector: A transform function to apply to each element.
     - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each element of the input sequence.
     */
    func flatMap<Result>(_ selector: @escaping (Element) throws -> Single<Result>) -> Maybe<Result> {
        self.flatMap { (element: Element) -> Maybe<Result> in
            let single = try selector(element)
            return single.asMaybe()
        }
    }
    
    /**
     Projects each element of an observable sequence to an observable sequence and merges the resulting observable sequences into one observable sequence.
     
     - seealso: [flatMap operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
     
     - parameter selector: A transform function to apply to each element.
     - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each element of the input sequence.
     */
    func flatMapCompletable(_ selector: @escaping (Element) throws -> Completable) -> Completable {
        asObservable()
            .flatMap(selector)
            .asCompletable()
    }
    
    /**
     Projects success element of a single trait sequence to an observable sequence.
     
     - seealso: [flatMap operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
     
     - parameter selector: A transform function to apply to an element.
     - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on success element.
     */
    func flatMapObservable<Result>(_ selector: @escaping (Element) throws -> Observable<Result>) -> Observable<Result> {
        asObservable()
            .flatMap(selector)
    }
}

// ******************************* MARK: - Maybe<[Element]>

public extension PrimitiveSequence where Trait == MaybeTrait, Element: Collection {
    
    /**
     Projects each element of an single collection into a new form.
     
     - parameter transform: A transform function to apply to each element of the source collection.
     - returns: An observable collection whose elements are the result of invoking the transform function on each element of source.
     */
    func mapMany<Result>(_ transform: @escaping (Element.Element) throws -> Result) -> Maybe<[Result]> {
        asObservable()
            .mapMany(transform)
            .asMaybe()
    }
}
