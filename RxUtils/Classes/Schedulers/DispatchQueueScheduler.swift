//
//  DispatchQueueScheduler.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 22.09.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Dispatch
import Foundation
import RxSwift

/// Abstracts the work that needs to be performed on a specific `dispatch_queue_t`.
///
/// This scheduler is suitable when some work needs to be performed in background.
/// - note: Copy & pasted from the `ConcurrentDispatchQueueScheduler` just to make sure it won't accidenty became concurrent for real.
public final class DispatchQueueScheduler: SchedulerType {
    typealias TimeInterval = Foundation.TimeInterval
    typealias Time = Date
    
    public var now: Date {
        Date()
    }
    
    public let configuration: DispatchQueueConfiguration
    
    /// Constructs new `DispatchQueueScheduler` that wraps `queue`.
    ///
    /// - parameter queue: Target dispatch queue.
    /// - parameter alwaysAsync: If `true` work is always performed async.
    /// Otherwise, if already on `queue` just performs work.
    /// - parameter leeway: The amount of time, in nanoseconds, that the system will defer the timer.
    public init(queue: DispatchQueue, alwaysAsync: Bool = true, leeway: DispatchTimeInterval = DispatchTimeInterval.nanoseconds(0)) {
        configuration = DispatchQueueConfiguration(queue: queue, alwaysAsync: alwaysAsync, leeway: leeway)
    }
    
    /**
     Schedules an action to be executed immediately.
     
     - parameter state: State passed to the action to be executed.
     - parameter action: Action to be executed.
     - returns: The disposable object used to cancel the scheduled action (best effort).
     */
    final public func schedule<StateType>(_ state: StateType, action: @escaping (StateType) -> Disposable) -> Disposable {
        configuration.schedule(state, action: action)
    }
    
    /**
     Schedules an action to be executed.
     
     - parameter state: State passed to the action to be executed.
     - parameter dueTime: Relative time after which to execute the action.
     - parameter action: Action to be executed.
     - returns: The disposable object used to cancel the scheduled action (best effort).
     */
    final public func scheduleRelative<StateType>(_ state: StateType, dueTime: RxTimeInterval, action: @escaping (StateType) -> Disposable) -> Disposable {
        configuration.scheduleRelative(state, dueTime: dueTime, action: action)
    }
    
    /**
     Schedules a periodic piece of work.
     
     - parameter state: State passed to the action to be executed.
     - parameter startAfter: Period after which initial work should be run.
     - parameter period: Period for running the work periodically.
     - parameter action: Action to be executed.
     - returns: The disposable object used to cancel the scheduled action (best effort).
     */
    public func schedulePeriodic<StateType>(_ state: StateType, startAfter: RxTimeInterval, period: RxTimeInterval, action: @escaping (StateType) -> StateType) -> Disposable {
        configuration.schedulePeriodic(state, startAfter: startAfter, period: period, action: action)
    }
}

/// - note: Copy & pasted from the `RxSwift`.
public struct DispatchQueueConfiguration {
    public let queue: DispatchQueue
    public let alwaysAsync: Bool
    public let leeway: DispatchTimeInterval
}

public extension DispatchQueueConfiguration {
    func schedule<StateType>(_ state: StateType, action: @escaping (StateType) -> Disposable) -> Disposable {
        let cancel = SingleAssignmentDisposable()
        
        let work: () -> Void = {
            if cancel.isDisposed {
                return
            }
            
            cancel.setDisposable(action(state))
        }
        
        if alwaysAsync {
            queue.async(execute: work)
        } else {
            queue.performAnyncIfNeeded(execute: work)
        }
        
        return cancel
    }
    
    func scheduleRelative<StateType>(_ state: StateType, dueTime: RxTimeInterval, action: @escaping (StateType) -> Disposable) -> Disposable {
        let deadline = DispatchTime.now() + dueTime
        
        let compositeDisposable = CompositeDisposable()
        
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: deadline, leeway: leeway)
        
        // TODO:
        // This looks horrible, and yes, it is.
        // It looks like Apple has made a conceputal change here, and I'm unsure why.
        // Need more info on this.
        // It looks like just setting timer to fire and not holding a reference to it
        // until deadline causes timer cancellation.
        var timerReference: DispatchSourceTimer? = timer
        let cancelTimer = Disposables.create {
            timerReference?.cancel()
            timerReference = nil
        }
        
        timer.setEventHandler(handler: {
            if compositeDisposable.isDisposed {
                return
            }
            _ = compositeDisposable.insert(action(state))
            cancelTimer.dispose()
        })
        timer.resume()
        
        _ = compositeDisposable.insert(cancelTimer)
        
        return compositeDisposable
    }
    
    func schedulePeriodic<StateType>(_ state: StateType, startAfter: RxTimeInterval, period: RxTimeInterval, action: @escaping (StateType) -> StateType) -> Disposable {
        let initial = DispatchTime.now() + startAfter
        
        var timerState = state
        
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: initial, repeating: period, leeway: leeway)
        
        // TODO:
        // This looks horrible, and yes, it is.
        // It looks like Apple has made a conceputal change here, and I'm unsure why.
        // Need more info on this.
        // It looks like just setting timer to fire and not holding a reference to it
        // until deadline causes timer cancellation.
        var timerReference: DispatchSourceTimer? = timer
        let cancelTimer = Disposables.create {
            timerReference?.cancel()
            timerReference = nil
        }
        
        timer.setEventHandler(handler: {
            if cancelTimer.isDisposed {
                return
            }
            timerState = action(timerState)
        })
        timer.resume()
        
        return cancelTimer
    }
}

// ******************************* MARK: - Main

public extension DispatchQueueScheduler {
    
    /// Always async queue with background priority
    static let background = DispatchQueueScheduler(queue: backgroundQueue)
    private static let backgroundQueue = DispatchQueue(label: "DispatchQueueScheduler_Background", qos: .background)
    
    /// The dispatch queue scheduler associated with the main queue and thread of the current process.
    static let main = DispatchQueueScheduler(queue: .main)
}

// ******************************* MARK: - DispatchQueue

private var c_keyAssociationKey = 0

private extension DispatchQueue {
    
    private var key: DispatchSpecificKey<Void> {
        get {
            if let key = objc_getAssociatedObject(self, &c_keyAssociationKey) as? DispatchSpecificKey<Void> {
                return key
            } else {
                let key = DispatchSpecificKey<Void>()
                setSpecific(key: key, value: ())
                objc_setAssociatedObject(self, &c_keyAssociationKey, key, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return key
            }
        }
    }
    
    /// Performs `work` on `self` asynchronously in not already on `self`.
    /// Otherwise, just performs `work`.
    func performAnyncIfNeeded(execute work: @escaping () -> Void) {
        if DispatchQueue.getSpecific(key: key) != nil {
            work()
        } else {
            async { work() }
        }
    }
    
    /// Performs `work` on `self` synchronously. Just performs `work` if already on `self`.
    func performSync<T>(execute work: () throws -> T) rethrows -> T {
        if DispatchQueue.getSpecific(key: key) != nil {
            return try work()
        } else {
            return try sync { try work() }
        }
    }
}
