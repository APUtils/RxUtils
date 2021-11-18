//
//  RxSwift+WithPrevious+ObservableType.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 7/31/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import APExtensions
import Foundation
import RxSwift

public extension ObservableType {
    
    /// Combines element with previous element. Previous element is `nil` on first element.
    func withPrevious() -> Observable<(Element?, Element)> {
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
    func withRequiredPrevious() -> Observable<(Element, Element)> {
        self.withPrevious()
            .compactMap { previous, current -> (Element, Element)? in
                guard let previous = previous else { return nil }
                return (previous, current)
        }
    }
}

// ******************************* MARK: - Optional

public extension ObservableType where Element: OptionalType {
    /// Combines element with previous element. Previous element is `nil` on first element.
    func withPrevious() -> Observable<(Element.Wrapped?, Element.Wrapped?)> {
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
