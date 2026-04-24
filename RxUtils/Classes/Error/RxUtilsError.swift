//
//  RxUtilsError.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 11/29/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation

public struct RxUtilsError: Error, Equatable, Codable {
    public let code: Int
    public let message: String
}
