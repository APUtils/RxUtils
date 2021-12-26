//
//  RxCocoa+Operators+Driver.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 14.11.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import APExtensions
import Foundation
import RxCocoa
import RxSwift

// ******************************* MARK: - Driver<Element>

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    
    /// Combines element with previous element. Previous element is `nil` on first element.
    func withPrevious() -> Driver<(Element?, Element)> {
        var _previous: Element?
        
        // Recursive is slower and we don't need it here
        let _lock = NSLock()
        
        return map { element -> (previous: Element?, current: Element) in
            _lock.lock(); defer { _lock.unlock() }
            defer { _previous = element }
            return (_previous, element)
        }
    }
    
    /// Combines element with previous element. First element with `nil` previous is ignored.
    func withRequiredPrevious() -> Driver<(Element, Element)> {
        self.withPrevious()
            .compactMap { previous, current -> (Element, Element)? in
                guard let previous = previous else { return nil }
                return (previous, current)
            }
    }
}

// ******************************* MARK: - Driver<Element?>

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element: OptionalType {
    /// Combines element with previous element. Previous element is `nil` on first element.
    func withPrevious() -> Driver<(Element.Wrapped?, Element.Wrapped?)> {
        var _previous: Element.Wrapped?
        
        // Recursive is slower and we don't need it here
        let _lock = NSLock()
        
        return map { element -> (previous: Element.Wrapped?, current: Element.Wrapped?) in
            _lock.lock(); defer { _lock.unlock() }
            defer { _previous = element.value }
            return (_previous, element.value)
        }
    }
}

// ******************************* MARK: - Driver<[Element]>

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element: Collection {
    /**
     Projects each element of an observable collection into a new form.
     
     - parameter transform: A transform function to apply to each element of the source collection.
     - returns: An observable collection whose elements are the result of invoking the transform function on each element of source.
     */
    func mapMany<Result>(_ transform: @escaping (Element.Element) -> Result) -> Driver<[Result]> {
        map { collection -> [Result] in
            collection.map(transform)
        }
    }
}
