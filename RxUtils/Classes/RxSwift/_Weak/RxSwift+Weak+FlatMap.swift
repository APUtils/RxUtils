//
//  RxSwift+Weak+FlatMap.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 4/11/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension ObservableType {
    
    private func weakify<A: AnyObject, B, O: ObservableConvertibleType>(_ obj: A, method: @escaping (A) -> (B) throws -> O) -> ((B) throws -> Observable<O.E>) {
        return { [weak obj] value throws -> Observable<O.E> in
            guard let obj = obj else { return .empty() }
            return try method(obj)(value).asObservable()
        }
    }
    
    // ******************************* MARK: - Flat Map First
    
    /**
     Projects each element of an observable sequence to an observable sequence and merges the resulting observable sequences into one observable sequence.
     If element is received while there is some projected observable sequence being merged it will simply be ignored.
     
     - seealso: [flatMapFirst operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter selector: A transform function to apply to element that was observed while no observable is executing in parallel.
     - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each element of the input sequence that was received while no other sequence was being calculated.
     */
    func flatMapFirst<A: AnyObject, O: ObservableConvertibleType>(weak obj: A, _ selector: @escaping (A) -> (Self.E) throws -> O) -> Observable<O.E> {
        return flatMapFirst(weakify(obj, method: selector))
    }
    
    /**
     Projects each element of an observable sequence into a new sequence of observable sequences and then
     transforms an observable sequence of observable sequences into an observable sequence producing values only from the most recent observable sequence.
     
     It is a combination of `map` + `switchLatest` operator
     
     - seealso: [flatMapLatest operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter selector: Transform function to apply on `weak` to each element in the observable sequence.
     - returns: An observable sequence whose elements are the result of invoking the transform function on each element of source producing an
     Observable of Observable sequences and that at any point in time produces the elements of the most recent inner observable sequence that has been received.
     */
    func flatMapFirst<A: AnyObject, O: ObservableConvertibleType>(weak obj: A, _ selector: @escaping (A, E) throws -> O) -> Observable<O.E> {
        return flatMapFirst { [weak obj] element -> Observable<O.E> in
            guard let obj = obj else { return .empty() }
            return try selector(obj, element).asObservable()
        }
    }
    
    // ******************************* MARK: - Flat Map Latest
    
    /**
     Projects each element of an observable sequence into a new sequence of observable sequences and then
     transforms an observable sequence of observable sequences into an observable sequence producing values only from the most recent observable sequence.
     
     It is a combination of `map` + `switchLatest` operator
     
     - seealso: [flatMapLatest operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter selector: Transform function to apply on `weak` to each element in the observable sequence.
     - returns: An observable sequence whose elements are the result of invoking the transform function on each element of source producing an
     Observable of Observable sequences and that at any point in time produces the elements of the most recent inner observable sequence that has been received.
     */
    func flatMapLatest<A: AnyObject, O: ObservableConvertibleType>(weak obj: A, _ selector: @escaping (A) -> (Self.E) throws -> O) -> Observable<O.E> {
        return flatMapLatest(weakify(obj, method: selector))
    }
    
    /**
     Projects each element of an observable sequence into a new sequence of observable sequences and then
     transforms an observable sequence of observable sequences into an observable sequence producing values only from the most recent observable sequence.
     
     It is a combination of `map` + `switchLatest` operator
     
     - seealso: [flatMapLatest operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter selector: Transform function to apply on `weak` to each element in the observable sequence.
     - returns: An observable sequence whose elements are the result of invoking the transform function on each element of source producing an
     Observable of Observable sequences and that at any point in time produces the elements of the most recent inner observable sequence that has been received.
     */
    func flatMapLatest<A: AnyObject, O: ObservableConvertibleType>(weak obj: A, _ selector: @escaping (A, E) throws -> O) -> Observable<O.E> {
        return flatMapLatest { [weak obj] element -> Observable<O.E> in
            guard let obj = obj else { return .empty() }
            return try selector(obj, element).asObservable()
        }
    }
    
    // ******************************* MARK: - Flat Map
    
    /**
     Projects each element of an observable sequence to an observable sequence and merges the resulting observable sequences into one observable sequence.
     
     - seealso: [flatMap operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter selector: Transform function to apply on `weak` to each element in the observable sequence.
     - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each element of the input sequence.
     */
    func flatMap<A: AnyObject, O: ObservableConvertibleType>(weak obj: A, _ selector: @escaping (A) -> (Self.E) throws -> O) -> Observable<O.E> {
        return flatMap(weakify(obj, method: selector))
    }
    
    /**
     Projects each element of an observable sequence to an observable sequence and merges the resulting observable sequences into one observable sequence.
     
     - seealso: [flatMap operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter selector: Transform function to apply on `weak` to each element in the observable sequence.
     - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each element of the input sequence.
     */
    func flatMap<A: AnyObject, O: ObservableConvertibleType>(weak obj: A, _ selector: @escaping (A, E) throws -> O) -> Observable<O.E> {
        return flatMap { [weak obj] element -> Observable<O.E> in
            guard let obj = obj else { return .empty() }
            return try selector(obj, element).asObservable()
        }
    }
}

// ******************************* MARK: - Void Support

extension ObservableType where E == Void {
    
    private func weakify<A: AnyObject, O: ObservableConvertibleType>(_ obj: A, method: @escaping (A) -> () throws -> O) -> (() throws -> Observable<O.E>) {
        return { [weak obj] in
            guard let obj = obj else { return .empty() }
            return try method(obj)().asObservable()
        }
    }
    
    /**
     Projects each element of an observable sequence into a new sequence of observable sequences and then
     transforms an observable sequence of observable sequences into an observable sequence producing values only from the most recent observable sequence.
     
     It is a combination of `map` + `switchLatest` operator
     
     - seealso: [flatMapLatest operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter selector: Transform function to apply on `weak` to each element in the observable sequence.
     - returns: An observable sequence whose elements are the result of invoking the transform function on each element of source producing an
     Observable of Observable sequences and that at any point in time produces the elements of the most recent inner observable sequence that has been received.
     */
    func flatMapLatest<A: AnyObject, O: ObservableConvertibleType>(weak obj: A, _ selector: @escaping (A) -> () throws -> O) -> Observable<O.E> {
        return flatMapLatest(weakify(obj, method: selector))
    }
    
    /**
     Projects each element of an observable sequence to an observable sequence and merges the resulting observable sequences into one observable sequence.
     
     - seealso: [flatMap operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter selector: Transform function to apply on `weak` to each element in the observable sequence.
     - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each element of the input sequence.
     */
    func flatMap<A: AnyObject, O: ObservableConvertibleType>(weak obj: A, _ selector: @escaping (A) -> () throws -> O) -> Observable<O.E> {
        return flatMap(weakify(obj, method: selector))
    }
    
    /**
     Projects each element of an observable sequence to an observable sequence and merges the resulting observable sequences into one observable sequence.
     
     - seealso: [flatMap operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter selector: Transform function to apply on `weak` to each element in the observable sequence.
     - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each element of the input sequence.
     */
    func flatMap<A: AnyObject, O: ObservableConvertibleType>(weak obj: A, _ selector: @escaping (A) throws -> O) -> Observable<O.E> {
        return flatMap { [weak obj] _ -> Observable<O.E> in
            guard let obj = obj else { return .empty() }
            return try selector(obj).asObservable()
        }
    }
}
