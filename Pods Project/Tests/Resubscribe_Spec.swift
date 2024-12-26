//
//  Resubscribe_Spec.swift
//  Carson
//
//  Created by Anton Plebanovich on 16.11.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

import Nimble
import Quick
import RxRelay
import RxSwift
import RxTest

fileprivate let kObserveOnDelay: Int = 1

final class Resubscribe_Spec: QuickSpec {
    
    override static func spec() {
        describe("resubscribeOnPossibleWakeUp") {
            
            context("when no wake up events were emitted") {
                it("should just pass received elements") {
                    runSimulation(wakeUpTime: .max)
                }
            }
            
            context("when wake up event was emitted before first event arrived") {
                it("should not affect events fire time") {
                    runSimulation(wakeUpTime: 205)
                    
                    // Checking unexpected case
                    runSimulation(wakeUpTime: 205)
                }
            }
            
            context("when wake up event was emitted after first event arrived") {
                it("should not affect events fire time") {
                    runSimulation(wakeUpTime: 215)
                }
            }
            
            context("when wake up event was emitted during subsequent operation") {
                it("should not cancel this operation") {
                    let scheduler = TestScheduler(initialClock: 0)
                    
                    let events = scheduler
                        .createHotObservable([
                            .init(time: 210, value: .next(()))
                        ])
                        .asObservable()
                    
                    let possiblyWakedUp = scheduler
                        .createHotObservable([.init(time: 215, value: .next(()))])
                        .asObservable()
                    
                    let observer = scheduler.start {
                        events
                            .resubscribeOnPossibleWakeUp(scheduler: scheduler,
                                                         possiblyWakedUp: possiblyWakedUp.asObservable(),
                                                         throttleDueTime: .nanoseconds(0))
                            .flatMapLatest { void -> Observable<Void> in
                                Observable<Int>.timer(.seconds(10), scheduler: scheduler)
                                    .mapToVoid()
                                    .startWith(void)
                            }
                    }
                    
                    expect(observer.events.count) == 2
                    expect(observer.events.first?.time) == 210
                    expect(observer.events.second?.time) == 220
                }
            }
            
            context("when wake up event was emitted during timer countdown") {
                it("should restart the countdown") {
                    let scheduler = TestScheduler(initialClock: 0)
                    
                    let possiblyWakedUp = scheduler
                        .createHotObservable([.init(time: 205, value: .next(()))])
                        .asObservable()
                    
                    let observer = scheduler.start {
                        Observable<Int>.timer(.seconds(10), scheduler: scheduler)
                            .mapToVoid()
                            .resubscribeOnPossibleWakeUp(scheduler: scheduler,
                                                         possiblyWakedUp: possiblyWakedUp.asObservable(),
                                                         throttleDueTime: .nanoseconds(0))
                    }
                    
                    expect(observer.events.count) == 2
                    
                    expect(observer.events.first?.time) == 215 + kObserveOnDelay
                    expect(observer.events.first?.value.isNext) == true
                    
                    expect(observer.events.second?.time) == 215 + kObserveOnDelay
                    expect(observer.events.second?.value.isCompleted) == true
                }
            }
            
            context("when wake up event was emitted on initial event observable") {
                it("should emit duplicated event") {
                    let scheduler = TestScheduler(initialClock: 0)
                    
                    let possiblyWakedUp = scheduler
                        .createHotObservable([.init(time: 205, value: .next(()))])
                        .asObservable()
                    
                    let observable = BehaviorRelay(value: ())
                    
                    let observer = scheduler.start {
                        observable
                            .resubscribeOnPossibleWakeUp(scheduler: scheduler,
                                                         possiblyWakedUp: possiblyWakedUp.asObservable(),
                                                         throttleDueTime: .nanoseconds(0))
                    }
                    
                    expect(observer.events.count) == 2
                    expect(observer.events.first?.time) == 200
                    expect(observer.events.second?.time) == 206
                }
            }
            
            context("when wake up event was emitted on initial event observable after it finished") {
                it("should not resubscribe after completed") {
                    let scheduler = TestScheduler(initialClock: 0)
                    
                    let possiblyWakedUp = scheduler
                        .createHotObservable([.init(time: 205, value: .next(()))])
                        .asObservable()
                    
                    let observer = scheduler.start {
                        Observable.just(())
                            .resubscribeOnPossibleWakeUp(scheduler: scheduler,
                                                         possiblyWakedUp: possiblyWakedUp.asObservable(),
                                                         throttleDueTime: .nanoseconds(0))
                    }
                    
                    expect(observer.events.count) == 2
                    
                    expect(observer.events.first?.time) == 200
                    expect(observer.events.first?.value.isNext) == true
                    
                    expect(observer.events.second?.time) == 200
                    expect(observer.events.second?.value.isCompleted) == true
                }
                
                it("should not resubscribe after errored") {
                    let scheduler = TestScheduler(initialClock: 0)
                    
                    let possiblyWakedUp: Observable<Void> = scheduler
                        .createHotObservable([.init(time: 205, value: .next(()))])
                        .asObservable()
                    
                    let observer = scheduler.start {
                        Observable<Void>.error(NSError(domain: "Resubscribe_Spec", code: -1))
                            .resubscribeOnPossibleWakeUp(scheduler: scheduler,
                                                         possiblyWakedUp: possiblyWakedUp.asObservable(),
                                                         throttleDueTime: .nanoseconds(0))
                    }
                    
                    expect(observer.events.count) == 1
                    expect(observer.events.first?.time) == 200
                }
            }
        }
    }
}

fileprivate func runSimulation(wakeUpTime: Int,
                               line: UInt = #line) {
    
    let scheduler = TestScheduler(initialClock: 0)
    
    let events = scheduler
        .createHotObservable([
            .init(time: 210, value: .next(())),
            .init(time: 220, value: .next(()))
        ])
        .asObservable()
    
    let possiblyWakedUp = scheduler
        .createHotObservable([.init(time: wakeUpTime, value: .next(()))])
        .asObservable()
    
    let observer = scheduler.start {
        events
            .resubscribeOnPossibleWakeUp(scheduler: scheduler,
                                         possiblyWakedUp: possiblyWakedUp,
                                         throttleDueTime: .nanoseconds(0))
    }
    
    expect(line: line, observer.events.count) == 2
    expect(line: line, observer.events.first?.time) == 210
    expect(line: line, observer.events.second?.time) == 220
}
