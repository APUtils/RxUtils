//
//  RxSwift+Operators+ObservableType.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 7/15/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

#if SPM
import APExtensionsOptionalType
#else
import APExtensions
#endif
import Foundation
import RxSwift

public extension RxUtilsError {
    static let noElements: RxUtilsError = .init(code: 1, message: "Subscription was completed without emmiting any elements.")
}

// ******************************* MARK: - ObservableType<Element>

public extension ObservableType {
    
    /// Same as `asSingle()` but completes right after gets the first element.
    /// Ordinary `asSingle()` waits for the completion event.
    func asSafeSingle() -> Single<Element> {
        return self
            .take(1)
            .asSingle()
    }
    
    /// Prevent error emission if observable chain had element.
    func catchErrorIfHadElement() -> Observable<Element> {
        let _recursiveLock = NSRecursiveLock()
        var _element: Element?
        
        return self
            .doOnNext {
                _recursiveLock.lock(); defer { _recursiveLock.unlock() }
                
                _element = $0
            }
            .catch {
                _recursiveLock.lock(); defer { _recursiveLock.unlock() }
                
                if _element != nil {
                    return .empty()
                } else {
                    return .error($0)
                }
            }
    }
    
    /// Throws `RxUtilsError.noElements` if sequence completed without emitting any elements.
    func errorIfNoElements() -> Observable<Element> {
        var gotElement = false
        
        return self
            .doOnNext { _ in
                gotElement = true
            }
            .doOnCompleted {
                if !gotElement {
                    throw RxUtilsError.noElements
                }
            }
    }
    
    /// Projects each element of an observable sequence into Any
    func mapToAny() -> Observable<Any> {
        return map { $0 }
    }
    
    /// Creates sequence that can not be disposed.
    /// - parameter disposeBag: Optional dispose bag that will be used to perform long-lasted subscription.
    /// - note: Please keep in mind that subscription is not disposed if sequence never ends.
    /// This may lead to infinite memory grow. 
    func preventDisposal(disposeBag: DisposeBag? = nil) -> Observable<Element> {
        return .create { observer in
            let recursiveLock = NSRecursiveLock()
            var observer: AnyObserver<Self.Element>? = observer
            let disposable = self.subscribe { event in
                recursiveLock.lock(); defer { recursiveLock.unlock() }
                observer?.on(event)
            }
            
            if let disposeBag = disposeBag {
                disposeBag.insert(disposable)
            }
            
            return Disposables.create {
                recursiveLock.lock(); defer { recursiveLock.unlock() }
                observer = nil
            }
        }
    }
    
    /// Wraps element into optional
    func wrapIntoOptional() -> Observable<Element?> {
        return self.map { $0 }
    }
    
    func flatMapLatestCompletable(_ selector: @escaping (Element) throws -> Completable) -> Completable {
        asObservable()
            .flatMapLatest(selector)
            .asCompletable()
    }
}

// ******************************* MARK: - ObservableType<[Element]?>

public extension ObservableType where Element: OptionalType, Element.Wrapped: Collection {
    
    /**
     Projects each element of an optional observable collection into a new form.
     
     - parameter transform: A transform function to apply to each element of the source collection.
     - returns: An observable collection whose elements are the result of invoking the transform function on each element of source.
     */
    func mapMany<Result>(_ transform: @escaping (Element.Wrapped.Element) throws -> Result) -> Observable<[Result]?> {
        return map { collection -> [Result]? in
            try collection.value?.map(transform)
        }
    }
}

// ******************************* MARK: - Filter with latest

public extension ObservableType {
    
    /// Apply filter to sequence using second sequence.
    /// - parameter second: Sequence to use for comparison.
    /// - parameter comparer: Equality comparer for computed key values.
    /// - returns: Filtered sequence.
    func filterWithLatestFrom<T: ObservableConvertibleType>(_ second: T, _ comparer: @escaping (Element, T.Element) -> Bool) -> Observable<Element> {
        return withLatestFrom(second) { ($0, $1) }
            .filter { comparer($0.0, $0.1) }
            .map { $0.0 }
    }
}

public extension ObservableType where Element: Equatable {
    
    /// Filters out element if it equals to the latest from provided sequence.
    /// - parameter second: Sequence to use for comparison.
    /// - returns: Filtered sequence.
    func filterEqualWithLatestFrom(_ second: Observable<Element>) -> Observable<Element> {
        return withLatestFrom(second) { ($0, $1) }
            .filter { $0 != $1 }
            .map { $0.0 }
    }
}
