//
//  RxSwift+WithPrevious+ObservableType.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 7/31/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional

public extension ObservableType {
    
    /// Combines element with previous element. Previous element is `nil` on first element.
    func withPrevious() -> Observable<(Element?, Element)> {
        self.scan([]) { previous, current in
                Array(previous + [current]).suffix(2)
            }
            .map { arr -> (previous: Element?, current: Element) in
                (arr.count > 1 ? arr.first : nil, arr.last!)
        }
    }
    
    /// Combines element with previous element. First element with `nil` previous is ignored.
    func withRequiredPrevious() -> Observable<(Element?, Element)> {
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
        self.scan([]) { previous, current in
                Array(previous + [current]).suffix(2)
            }
            .map { arr -> (previous: Element.Wrapped?, current: Element.Wrapped?) in
                (arr.first?.value, arr.last?.value)
        }
    }
}
