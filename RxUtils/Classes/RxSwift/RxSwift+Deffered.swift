//
//  RxSwift+Deffered.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 4/12/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift


extension ObservableType {
    
    /// Evaluates startWith expression on subscribe and pass it as element to a sequence.
    /// Do not emit anything if evaluates to nil.
    func startWithDeferred(_ element: @escaping @autoclosure () -> E?) -> Observable<E> {
        return Observable.create {
            if let element = element() {
                return self
                    .startWith(element)
                    .subscribe($0)
            } else {
                return self
                    .subscribe($0)
            }
        }
    }
}
