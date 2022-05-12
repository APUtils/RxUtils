//
//  RxSwift+Error+ObservableConvertibleType.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 4/11/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt
import RoutableLogger

public extension ObservableConvertibleType {
    
    /// Maps error into other error.
    /// - parameter transform: A transform function to apply to source error.
    func mapError(_ transform: @escaping (Error) -> Error) -> Observable<Element> {
        asObservable().catch { error -> Observable<Element> in .error(transform(error)) }
    }
    
    /// Maps error into other error.
    /// - parameter error: Error to transform to.
    func mapErrorTo(_ error: Error) -> Observable<Element> {
        asObservable().catch { _ -> Observable<Element> in .error(error) }
    }
    
    /// Catches error and just completes sequence
    func catchErrorJustComplete() -> Observable<Element> {
        asObservable().catch { _ in Observable<Element>.empty() }
    }
    
    /// Catches error and just completes if `check` passes.
    /// - Parameter check: Check to execute on received error.
    func catchErrorJustComplete(_ check: @escaping (Error) -> Bool) -> Observable<Element> {
        asObservable().catch { error -> Observable<Element> in
            if check(error) {
                return .empty()
            } else {
                return .error(error)
            }
        }
    }
    
    /// Retries sequence if condition is met.
    func retryIf(_ if: @escaping (Error) -> Bool) -> Observable<Element> {
        asObservable().retry { observableError in
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
    
    /// Reports an error if a sequence receives an error. Crashes during debug.
    func assertNoErrors(file: String = #file, function: String = #function, line: UInt = #line) -> Observable<Element> {
        asObservable().doOnError {
            let message = "Unexpected rx sequence error"
            RoutableLogger.logError(message, error: $0, file: file, function: function, line: line)
            assertionFailure(message)
        }
    }
}
