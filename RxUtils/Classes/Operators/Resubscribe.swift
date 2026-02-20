//
//  Resubscribe.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 26.12.24.
//  Copyright © 2024 Anton Plebanovich. All rights reserved.
//

import RoutableLogger
import RxSwift
import UIKit

public extension Observable<Void> {
#if DEBUG
    /// Changeble for unit tests
    static var possiblyWakedUp: Observable<Void> = UIApplication.shared.rx.didLeaveBackground
#else
    static let possiblyWakedUp: Observable<Void> = UIApplication.shared.rx.didLeaveBackground
#endif
}

public extension ObservableConvertibleType {
    
    /// Restarts subscription on possibly waked up events.
    ///
    /// It looks like Realm observations might stop working at some point so data just keeps collecting
    /// in the memory and on the disk and causes out of memory crash at some point. Just to be safe we need to
    /// resubscribe time to time and it looks meaningful to do it during possibly waked up events.
    ///
    /// While we receive more stability with this approach there is a drawback of duplicate events and increased
    /// complexity but it should be worth it. We can always stop using this approach later if we believe that the core
    /// issue was resolved.
    ///
    /// - warning: You should be ready to receive duplicated events on resubscribe if that is a source behavior.
    /// Usually, it can be easily fixed by using `.distinctUntilChanged()` operator. Skipping is not recommended
    /// because you may miss events if they arrive during resubscribe operation because of the race conditions.
    ///
    /// - warning: You should be ready that some events will be missed because of race conditions if they arrive during
    /// resubscribe operation so it isn't recommended to use resubscribe on signal type observables that don't emit the
    /// latest event.
    func resubscribeOnPossibleWakeUp(scheduler: SchedulerType,
                                     possiblyWakedUp: Observable<Void> = .possiblyWakedUp,
                                     throttleDueTime: RxTimeInterval = .seconds(60),
                                     label: String? = nil,
                                     file: String = #file,
                                     function: String = #function,
                                     line: UInt = #line) -> Observable<Element> {
        
        let _recursiveLock = NSRecursiveLock()
        var _initial = true
        
        let observable = asObservable()
        
        return Observable.create { observer in
            possiblyWakedUp
                .observe(on: scheduler)
            // Produce initial event to start initial subscription.
                .startWith(())
            // We do not need multiple events, just one
                .throttle(throttleDueTime, latest: false, scheduler: scheduler)
                .flatMapLatest { _ -> Observable<Element> in
                    _recursiveLock.lock(); defer { _recursiveLock.unlock() }
                    
                    let label = label ?? file._fileName
                    if _initial {
                        _initial = false
                        RoutableLogger.logVerbose("Performing initial subscription on \(label):\(line)", file: file, function: function, line: line)
                        
                    } else {
                        RoutableLogger.logVerbose("Performing resubscribe on \(label):\(line)", file: file, function: function, line: line)
                    }
                    
                    return observable
                    // Finish whole sequence if base sequece completes
                        .doOnCompleted { observer.onCompleted() }
                }
                .bind(to: observer)
        }
    }
}

public extension PrimitiveSequence where Trait == SingleTrait {
    
    /// Restarts subscription on possibly waked up events.
    ///
    /// It looks like Realm observations might stop working at some point so data just keeps collecting
    /// in the memory and on the disk and causes out of memory crash at some point. Just to be safe we need to
    /// resubscribe time to time and it looks meaningful to do it during possibly waked up events.
    ///
    /// - warning: You should be ready to receive duplicated events on resubscribe if that is a source behavior.
    /// Usually, it can be easily fixed by using `.distinctUntilChanged()` operator. Skipping is not recommended
    /// because you may miss events if they arrive during resubscribe operation because of the race conditions.
    ///
    /// - warning: You should be ready that some events will be missed because of race conditions if they arrive during
    /// resubscribe operation.
    func resubscribeOnPossibleWakeUp(scheduler: SchedulerType,
                                     possiblyWakedUp: Observable<Void> = .possiblyWakedUp,
                                     label: String? = nil,
                                     file: String = #file,
                                     function: String = #function,
                                     line: UInt = #line) -> Single<Element> {
        
        asObservable()
            .resubscribeOnPossibleWakeUp(scheduler: scheduler,
                                         possiblyWakedUp: possiblyWakedUp,
                                         label: label,
                                         file: file,
                                         function: function,
                                         line: line)
            .asSingle()
    }
}
