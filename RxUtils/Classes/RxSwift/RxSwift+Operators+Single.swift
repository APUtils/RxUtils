//
//  RxSwift+Operators+Single.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 12/5/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

#if SPM
import APExtensionsOptionalType
#else
import APExtensions
#endif
import Foundation
import RxSwift
import RxSwiftExt

// ******************************* MARK: - Single

public extension PrimitiveSequence where Trait == SingleTrait {
    
    /// Projects each element of an observable sequence into Any
    func mapToAny() -> Single<Any> {
        return map { $0 }
    }
    
    /// Projects each element of an observable sequence into Void
    func mapToVoid() -> Single<Void> {
        return map { _ in () }
    }
    
    /// Creates sequence that can not be disposed.
    /// - parameter disposeBag: Optional dispose bag that will be used to perform long-lasted subscription.
    /// - note: Please keep in mind that subscription is not disposed if sequence never ends.
    /// This may lead to infinite memory grow. 
    func preventDisposal(disposeBag: DisposeBag? = nil) -> Single<Element> {
        return .create { observer in
            let recursiveLock = NSRecursiveLock()
            var observer: ((Result<Element, Error>) -> Void)? = observer
            
            let disposable = self.subscribe { event in
                recursiveLock.lock(); defer { recursiveLock.unlock() }
                observer?(event)
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
    func wrapIntoOptional() -> Single<Element?> {
        return map { $0 }
    }
    
    /**
     Pauses the elements of the source single sequence based on the latest element from the second observable sequence.
     
     While paused, elements from the source are buffered, limited to a single element.
     
     When resumed, the buffered element, if present, is flushed.
     
     - seealso: [pausable operator on reactivex.io](http://reactivex.io/documentation/operators/backpressure.html)
     
     - parameter pauser: The observable sequence used to pause the source observable sequence.
     - returns: The single sequence which is paused and resumed based upon the pauser observable sequence.
     */
    func pausableBuffered<Pauser: ObservableType>(_ pauser: Pauser) -> Single<Element> where Pauser.Element == Bool {
        asObservable()
            .pausableBuffered(pauser)
            .asSingle()
    }
    
    /**
     Projects success element of a single trait sequence to an observable sequence.
     
     - seealso: [flatMap operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)
     
     - parameter selector: A transform function to apply to an element.
     - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on success element.
     */
    func flatMapObservable<Result>(_ selector: @escaping (Element) throws -> Observable<Result>) -> Observable<Result> {
        asObservable()
            .flatMap(selector)
    }
    
    /**
     Repeats the source single sequence using given behavior in case of an error or until it successfully terminated
     - parameter behavior: Behavior that will be used in case of an error
     - parameter scheduler: Scheduler that will be used for delaying subscription after error
     - parameter shouldRetry: Custom optional closure for checking error (if returns true, repeat will be performed)
     - returns: Single sequence that will be automatically repeat if error occurred
     */
    func retry(_ behavior: RepeatBehavior,
               scheduler: SchedulerType = MainScheduler.instance,
               shouldRetry: RetryPredicate? = nil) -> Single<Element> {
        
        asObservable()
            .retry(behavior, scheduler: scheduler, shouldRetry: shouldRetry)
            .asSingle()
    }
    
    /**
     Returns a single sequence that **shares a single subscription to the underlying sequence**, and immediately upon subscription replays  elements in buffer.
     
     This operator is equivalent to:
     * `.whileConnected`
     ```
     // Each connection will have it's own subject instance to store replay events.
     // Connections will be isolated from each another.
     source.multicast(makeSubject: { Replay.create(bufferSize: replay) }).refCount()
     ```
     * `.forever`
     ```
     // One subject will store replay events for all connections to source.
     // Connections won't be isolated from each another.
     source.multicast(Replay.create(bufferSize: replay)).refCount()
     ```
     
     It uses optimized versions of the operators for most common operations.
     
     - parameter scope: Lifetime scope of sharing subject. For more information see `SubjectLifetimeScope` enum.
     
     - seealso: [shareReplay operator on reactivex.io](http://reactivex.io/documentation/operators/replay.html)
     
     - returns: A single sequence that contains the elements of a sequence produced by multicasting the source sequence.
     */
    func share(scope: SubjectLifetimeScope = .whileConnected) -> Single<Element> {
        asObservable()
            .share(replay: 1, scope: scope)
            .asSingle()
    }
}

// ******************************* MARK: - Single<Collection>

public extension PrimitiveSequence where Trait == SingleTrait, Element: Collection {
    
    /**
     Projects each element of a single collection into a new form.
     
     - parameter transform: A transform function to apply to each element of the source collection.
     - returns: A single collection whose elements are the result of invoking the transform function on each element of source.
     */
    func mapMany<Result>(_ transform: @escaping (Element.Element) throws -> Result) -> Single<[Result]> {
        return map { collection -> [Result] in
            try collection.map(transform)
        }
    }
}

// ******************************* MARK: - Single<Element?>

public extension PrimitiveSequence where Trait == SingleTrait, Element: OptionalType {
    
    /**
     Throws an error if the source `Observable` contains an empty element; otherwise returns original source `Observable` of non-empty elements.
     
     - parameter error: error to throw when an empty element is encountered. Defaults to `RxOptionalError.FoundNilWhileUnwrappingOptional`.
     
     - throws: `error` if an empty element is encountered.
     
     - returns: original source `Observable` of non-empty elements if it contains no empty elements.
     */
    
    func errorOnNil(_ error: Error = RxOptionalError.foundNilWhileUnwrappingOptional(Element.self)) -> Single<Element.Wrapped> {
        map { element -> Element.Wrapped in
            guard let value = element.value else {
                throw error
            }
            return value
        }
    }
    
    /**
     Unwraps and filters out `nil` elements.
     
     - returns: `Maybe` of source `Single`'s elements, with `nil` elements filtered out.
     */
    func filterNil() -> Maybe<Element.Wrapped> {
        asObservable().filterNil().asMaybe()
    }
}
