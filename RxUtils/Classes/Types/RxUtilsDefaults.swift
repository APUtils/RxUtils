//
//  RxUtilsDefaults.swift
//  Pods
//
//  Created by Anton Plebanovich on 4.08.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

import RxSwift

public enum RxUtilsDefaults {
    
    /// Default tap throttle
    public static var tapThrottle: RxTimeInterval = .milliseconds(500)
}
