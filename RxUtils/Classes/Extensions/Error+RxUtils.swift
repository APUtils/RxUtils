//
//  String+Extension.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 12.05.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

public extension Error {
    
    var asRxError: RxError? {
        self as? RxError
    }
}
