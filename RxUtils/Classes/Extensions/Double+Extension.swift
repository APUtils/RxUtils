//
//  Double+Extension.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 12.05.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

import Foundation

extension Double {
    
    /// Returns string representation rounded to hundredth
    /// - note: It uses posix locale
    var _hundredthString: String {
        NumberFormatter._hundredth._stringOrEmpty(from: self)
    }
}
