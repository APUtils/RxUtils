//
//  BackgroundSafeTimer.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 3/2/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RoutableLogger
import UIKit

// ******************************* MARK: - ObservableType

@available(iOSApplicationExtension, unavailable)
public extension ObservableType where Element == Void {
    
    /**
     Returns an observable sequence that periodically produces a value after the specified initial relative due time has elapsed, using the specified scheduler to run timers.
     
     It works around the issue of broken timer in the background. Please check specs for more info.
     
     - seealso: [timer operator on reactivex.io](http://reactivex.io/documentation/operators/timer.html)
     
     - parameter dueTime: Relative time at which to produce the first value.
     - parameter period: Period to produce subsequent values.
     - parameter scheduler: Scheduler to run timers on.
     - parameter possiblyWakedUp: There is no system event for application wake up from suspension nor go to suspension so we have to guess. By default only the app leave from the background is checked but if your app works in the background you should add more: push location, push notification or background fetch.
     - parameter timerScheduler: Just for tests.
     - returns: An observable sequence that produces a value after due time has elapsed and then each period.
     */
    static func backgroundSafeTimer(
        _ dueTime: RxSwift.RxTimeInterval,
        period: RxSwift.RxTimeInterval?,
        scheduler: SchedulerType,
        possiblyWakedUp: Observable<Void> = UIApplication.shared.rx.didLeaveBackground.subscribe(on: ConcurrentMainScheduler.instance),
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        timerScheduler: @escaping (_ dueTime: RxSwift.RxTimeInterval,
                                   _ period: RxSwift.RxTimeInterval?,
                                   _ scheduler: SchedulerType) -> Observable<Int> = Observable<Int>.timer(_:period:scheduler:)) -> Observable<Void> {
        
        var period = period
        if period == .never {
            period = nil
        }
        
        let recursiveLock = NSRecursiveLock()
        var dueDate: Date!
        let dueTimeTimeInterval = dueTime.asTimeInterval
        let periodTimeInterval = period?.asTimeInterval
        var lastEventDate: Date?
        
        var backgroundSafeTimer = possiblyWakedUp
        // Produce initial event to start initial timer.
            .startWith(())
        // We need to reinstall timer each time the app possibly wakes up but keep the same events time position.
            .flatMapLatest { _ -> Observable<Void> in
                recursiveLock.lock(); defer { recursiveLock.unlock() }
                
                var emitNow = false
                var fixedDueTime = dueDate.timeIntervalSince(scheduler.now)
                if fixedDueTime < 0 {
                    // Initial due time elapsed and so event should be emited.
                    // We need to check if we should emit event right now or skip.
                    if let lastEventDate = lastEventDate {
                        if let periodTimeInterval = periodTimeInterval {
                            // Missed repeated event. Emit now.
                            if scheduler.now.timeIntervalSince(lastEventDate) >= periodTimeInterval {
                                emitNow = true
                            }
                            
                        } else {
                            RoutableLogger.logError("Unexpected timer reschedule after first event emit", data: ["dueTime": dueTime, "period": period, "now": scheduler.now, "dueDate": dueDate], file: file, function: function, line: line)
                        }
                        
                    } else {
                        // Missed initial event. Emit now.
                        emitNow = true
                    }
                    
                    if let periodTimeInterval = periodTimeInterval {
                        // Compute fixed due time to the next event
                        fixedDueTime = periodTimeInterval + fixedDueTime.truncatingRemainder(dividingBy: periodTimeInterval)
                        
                    } else if emitNow {
                        // There is no period but initial event was missed so just emit it
                        return Observable.just(())
                            .observe(on: scheduler)
                        
                    } else {
                        RoutableLogger.logError("Unexpected timer reschedule state", data: ["dueTime": dueTime, "period": period, "now": scheduler.now, "dueDate": dueDate, "emitNow": emitNow], file: file, function: function, line: line)
                        
                        return .empty()
                    }
                    
                } else {
                    // First event not yet fired so just schedule new timer with positive fixed due time
                }
                
                RoutableLogger.logVerbose("\(file._fileName):\(line) | Scheduling background safe timer with \(fixedDueTime._hundredthString) due time interval", file: file, function: function, line: line)
                var timer = timerScheduler(fixedDueTime.asRxTimeInterval,
                                           period,
                                           scheduler)
                    .mapToVoid()
                
                if emitNow {
                    // Applying `observeOn` to the emit now event only
                    timer = Observable.merge(Observable.just(()).observe(on: scheduler),
                                             timer)
                }
                
                return timer
            } // flatMapLatest
        
        // We need to stop rescheduling if we don't have a `period` after the first event arrived
        if period == nil {
            backgroundSafeTimer = backgroundSafeTimer
                .take(1)
            
        } else {
            backgroundSafeTimer = backgroundSafeTimer
                .doOnNext { _ in
                    recursiveLock.lock(); defer { recursiveLock.unlock() }
                    
                    lastEventDate = scheduler.now
                }
        }
        
        return backgroundSafeTimer
        // The initial timer is created after we subscribe instead of when we call the method
        // so we need to update `scheduleDate`.
            .doOnSubscribe {
                dueDate = scheduler.now.addingTimeInterval(dueTimeTimeInterval)
            }
    }
}

// ******************************* MARK: - SharedSequence

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element == Void {
    
    /**
     Returns an observable sequence that periodically produces a value after the specified initial relative due time has elapsed, using the specified scheduler to run timers.
     
     It works around the issue of broken timer in the background. Please check specs for more info.
     
     - seealso: [timer operator on reactivex.io](http://reactivex.io/documentation/operators/timer.html)
     
     - parameter dueTime: Relative time at which to produce the first value.
     - parameter period: Period to produce subsequent values.
     - parameter scheduler: Scheduler to run timers on.
     - parameter possiblyWakedUp: There is no system event for application wake up from suspension nor go to suspension so we have to guess. By default only the app leave from the background is checked but if your app works in the background you should add more: push location, push notification or background fetch.
     - parameter timerScheduler: Just for tests.
     - returns: A driver that produces a value after due time has elapsed and then each period.
     */
    static func backgroundSafeTimer(
        _ dueTime: RxSwift.RxTimeInterval,
        period: RxSwift.RxTimeInterval?,
        possiblyWakedUp: Observable<Void> = UIApplication.shared.rx.didLeaveBackground.subscribe(on: ConcurrentMainScheduler.instance),
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        timerScheduler: @escaping (
            _ dueTime: RxSwift.RxTimeInterval,
            _ period: RxSwift.RxTimeInterval?
        ) -> Driver<Int> = Driver<Int>.timer(_:period:)
    ) -> Driver<Void> {
        
        Observable.backgroundSafeTimer(
            dueTime,
            period: period, 
            scheduler: SharingStrategy.scheduler,
            possiblyWakedUp: possiblyWakedUp,
            file: file, 
            function: function,
            line: line,
            timerScheduler: { dueTime, period, _ in
                timerScheduler(dueTime, period).asObservable()
            }
        )
        .asDriver(onErrorDriveWith: .empty())
    }
}

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element: RxAbstractInteger {
    
    static func timer(_ dueTime: RxTimeInterval, period: RxTimeInterval?) -> Driver<Element> {
        Observable<Element>.timer(dueTime, period: period, scheduler: SharingStrategy.scheduler)
            .asDriver(onErrorDriveWith: .empty())
    }
}
