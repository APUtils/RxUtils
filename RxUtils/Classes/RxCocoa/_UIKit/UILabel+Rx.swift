//
//  UILabel+Rx.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 3/23/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UILabel {
    
    /// Label text color binder
    var textColor: Binder<UIColor?> {
        Binder(base) { label, textColor in
            label.textColor = textColor
        }
    }
}
