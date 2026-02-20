//
//  ControlEvent.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 9.08.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

import RxCocoa
import RxSwift

extension ControlEvent {
    /// Merges elements from all control event sequences from collection into a single control event sequence.
    ///
    /// - seealso: [merge operator on reactivex.io](http://reactivex.io/documentation/operators/merge.html)
    ///
    /// - parameter sources: Collection of control event sequences to merge.
    /// - returns: The control event sequence that merges the elements of the control event sequences.
    public static func merge<Collection: Swift.Collection>(_ sources: Collection) -> ControlEvent<Element> where Collection.Element == ControlEvent<Element> {
        let observableSources = sources.map { $0.asObservable() }
        return ControlEvent(events: Observable.merge(observableSources))
    }
    
    /// Merges elements from all control event sequences from collection into a single control event sequence.
    ///
    /// - seealso: [merge operator on reactivex.io](http://reactivex.io/documentation/operators/merge.html)
    ///
    /// - parameter sources: Array of control event sequences to merge.
    /// - returns: The control event sequence that merges the elements of the control event sequences.
    public static func merge(_ sources: [ControlEvent<Element>]) -> ControlEvent<Element> {
        let observableSources = sources.map { $0.asObservable() }
        return ControlEvent(events: Observable.merge(observableSources))
    }
    
    /// Merges elements from all control event sequences from collection into a single control event sequence.
    ///
    /// - seealso: [merge operator on reactivex.io](http://reactivex.io/documentation/operators/merge.html)
    ///
    /// - parameter sources: Collection of control event sequences to merge.
    /// - returns: The control event sequence that merges the elements of the control event sequences.
    public static func merge(_ sources: ControlEvent<Element>...) -> ControlEvent<Element> {
        let observableSources = sources.map { $0.asObservable() }
        return ControlEvent(events: Observable.merge(observableSources))
    }
}
