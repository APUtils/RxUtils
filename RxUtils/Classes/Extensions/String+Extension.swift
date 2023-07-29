//
//  String+Extension.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 12.05.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

import Foundation

extension String {
    
    /// Returns fileName without extension
    var _fileName: String {
        guard let lastPathComponent = components(separatedBy: "/").last else { return "" }
        
        var components = lastPathComponent.components(separatedBy: ".")
        if components.count == 1 {
            return lastPathComponent
        } else {
            components.removeLast()
            return components.joined(separator: ".")
        }
    }
}
