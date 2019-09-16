//
//  RxSwift+Optional+ObservableType.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 9/16/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

public extension ObservableType {
    /// Wraps element into optional
    func wrapIntoOptional() -> Observable<Element?> {
        return self.map { $0 }
    }
}
