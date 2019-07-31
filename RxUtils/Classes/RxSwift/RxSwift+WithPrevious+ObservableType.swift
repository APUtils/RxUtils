//
//  RxSwift+WithPrevious+ObservableType.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 7/31/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

public extension ObservableType {
    /// Combines element with previous element. Previous element is `nil` on first element.
    func withPrevious() -> Observable<(Element?, Element)> {
        return self
            .scan([]) { (previous, current) in
                Array(previous + [current]).suffix(2)
            }
            .map { (arr) -> (previous: Element?, current: Element) in
                (arr.count > 1 ? arr.first : nil, arr.last!)
        }
    }
}
