//
//  RxSwift+Error+ObservableType.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 4/11/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt

public extension ObservableType {
    /// Maps error into other error.
    /// - parameter transform: A transform function to apply to source error.
    func mapError(_ transform: @escaping (Error) -> Error) -> Observable<Element> {
        return self.catch { error -> Observable<Element> in .error(transform(error)) }
    }
    
    /// Maps error into other error.
    /// - parameter error: Error to transform to.
    func mapErrorTo(_ error: Error) -> Observable<Element> {
        return self.catch { error -> Observable<Element> in .error(error) }
    }
    
    /// Catches error and just completes if `check` passes.
    /// - Parameter check: Check to execute on received error.
    func catchErrorJustComplete(_ check: @escaping (Error) -> Bool) -> Observable<Element> {
        return self.catch { error -> Observable<Element> in
            if check(error) {
                return .empty()
            } else {
                return .error(error)
            }
        }
    }
    
    /// Retries sequence if condition is met.
    func retryIf(_ if: @escaping (Error) -> Bool) -> Observable<Element> {
        retry { observableError in
            observableError
                .map { error -> Bool in
                    if `if`(error) {
                        return true
                    } else {
                        throw error
                    }
                }
        }
    }
}
