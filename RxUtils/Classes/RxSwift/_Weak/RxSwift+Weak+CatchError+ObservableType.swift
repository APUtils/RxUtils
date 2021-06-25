//
//  RxSwift+Weak+CatchError+ObservableType.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 7/30/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

public extension ObservableType {
    /**
     Continues an observable sequence that is terminated by an error with the observable sequence produced by the handler. Returns empty sequence if `weak` object became `nil`.
     
     - seealso: [catch operator on reactivex.io](http://reactivex.io/documentation/operators/catch.html)
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter handler: Error handler function, producing another observable sequence. It isn't called if `weak` object was deallocated.
     - returns: An observable sequence containing the source sequence's elements, followed by the elements produced by the handler's resulting observable sequence in case an error occurred.
     */
    func catchError<A: AnyObject>(weak obj: A, _ handler: @escaping (A) -> (Error) throws -> Observable<Element>) -> Observable<Element> {
        return self.catch { [weak obj] error throws -> Observable<Element> in
            guard let obj = obj else { return .empty() }
            return try handler(obj)(error)
        }
    }
    
    /**
     Continues an observable sequence that is terminated by an error with the observable sequence produced by the handler. Returns empty sequence if `weak` object became `nil`.
     
     - seealso: [catch operator on reactivex.io](http://reactivex.io/documentation/operators/catch.html)
     
     - parameter weak: Weakly referenced object.
     - parameter handler: Error handler function, producing another observable sequence. It isn't called if `weak` object was deallocated.
     - returns: An observable sequence containing the source sequence's elements, followed by the elements produced by the handler's resulting observable sequence in case an error occurred.
     */
    func catchError<A: AnyObject>(weak obj: A, _ handler: @escaping (A, Error) throws -> Observable<Element>) -> Observable<Element> {
        return self.catch { [weak obj] error throws -> Observable<Element> in
            guard let obj = obj else { return .empty() }
            return try handler(obj, error)
        }
    }
    
    /**
     Continues an observable sequence that is terminated by an error with the observable sequence produced by the handler. Returns empty sequence if `weak` object became `nil`.
     
     - seealso: [catch operator on reactivex.io](http://reactivex.io/documentation/operators/catch.html)
     
     - parameter weak: Weakly referenced object.
     - parameter handler: Error handler function, producing another observable sequence. It isn't called if `weak` object was deallocated.
     - returns: An observable sequence containing the source sequence's elements, followed by the elements produced by the handler's resulting observable sequence in case an error occurred.
     */
    func catchError<A: AnyObject>(weak obj: A, _ handler: @escaping (A) -> () throws -> Observable<Element>) -> Observable<Element> {
        return self.catch { [weak obj] error throws -> Observable<Element> in
            guard let obj = obj else { return .empty() }
            return try handler(obj)()
        }
    }
}
