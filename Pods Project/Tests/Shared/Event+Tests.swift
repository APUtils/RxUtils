//
//  Event+Tests.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 3/2/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import RxSwift

extension Event {
    
    /// Returns `true` if `self` is a `.next` event.
    var isNext: Bool {
        switch self {
        case .next: return true
        default: return false
        }
    }
}
