//
//  NumberFormatter+Extension.swift
//  Pods
//
//  Created by Anton Plebanovich on 12.05.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

import Foundation

extension NumberFormatter {
    
    /// - note: It uses posix locale
    static let _hundredth: NumberFormatter = {
        let nf = NumberFormatter()
        nf.locale = ._posix
        nf.minimumIntegerDigits = 1
        nf.maximumFractionDigits = 2
        return nf
    }()
    
    func _stringOrEmpty(from: Double) -> String {
        string(from: from as NSNumber) ?? ""
    }
}
