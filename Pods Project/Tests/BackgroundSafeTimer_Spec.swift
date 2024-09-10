//
//  BackgroundSafeTimer_Spec.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 3/2/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

#if SPM
import APExtensionsDispatch
import APExtensionsOccupiable
import APExtensionsOptionalType
#else
import APExtensions
#endif
import Nimble
import Quick
import RxRelay
import RxSwift
import RxTest
import RxUtils

fileprivate let kObserveOnDelay: Int = 1

final class BackgroundSafeTimer_Spec: QuickSpec {
    
    override static func spec() {
        describe("backgroundSafeTimer") {
            context("when initial event not yet emitted") {
                it("should properly reschedule timer on wake up event") {
                    let events = runSimulation(dueTime: .seconds(2),
                                               period: nil,
                                               suspendTimeRange: nil,
                                               wakeUpTimes: [201])
                    
                    expect(events.count) == 2
                    
                    expect(events.first?.time) == 202
                    expect(events.first?.value.isNext) == true
                    
                    expect(events.second?.time) == 202
                    expect(events.second?.value.isCompleted) == true
                }
                
                context("and period is .never") {
                    it("should properly reschedule timer on wake up event") {
                        let events = runSimulation(dueTime: .seconds(2),
                                                   period: .never,
                                                   suspendTimeRange: nil,
                                                   wakeUpTimes: [201])
                        
                        expect(events.count) == 2
                        
                        expect(events.first?.time) == 202
                        expect(events.first?.value.isNext) == true
                        
                        expect(events.second?.time) == 202
                        expect(events.second?.value.isCompleted) == true
                    }
                }
            }
            
            context("when initial event was emitted during suspension") {
                context("and timer is periodic") {
                    it("should emit initial event after suspension finish on wake up event and properly reschedule timer") {
                        let events = runSimulation(dueTime: .seconds(2),
                                                   period: .seconds(500),
                                                   suspendTimeRange: 0..<300,
                                                   wakeUpTimes: [300])
                        
                        expect(events.count) == 2
                        
                        expect(events.first?.time) == 300 + kObserveOnDelay
                        expect(events.first?.value.isNext) == true
                        
                        expect(events.second?.time) == 702 // 200 + 2 + 500
                        expect(events.second?.value.isNext) == true
                    }
                }
                
                context("and timer is not periodic") {
                    it("should emit initial event after suspension finish on wake up event") {
                        let events = runSimulation(dueTime: .seconds(2),
                                                   period: nil,
                                                   suspendTimeRange: 0..<300,
                                                   wakeUpTimes: [300])
                        
                        expect(events.count) == 2
                        
                        expect(events.first?.time) == 300 + kObserveOnDelay
                        expect(events.first?.value.isNext) == true
                        
                        expect(events.second?.time) == 300 + kObserveOnDelay
                        expect(events.second?.value.isCompleted) == true
                    }
                }
            }
            
            context("when initial event was emitted") {
                context("and timer is not periodic") {
                    it("should ignore wake up event") {
                        let events = runSimulation(dueTime: .seconds(2),
                                                   period: nil,
                                                   suspendTimeRange: nil,
                                                   wakeUpTimes: [204])
                        
                        expect(events.count) == 2
                        
                        expect(events.first?.time) == 202
                        expect(events.first?.value.isNext) == true
                        
                        expect(events.second?.time) == 202
                        expect(events.second?.value.isCompleted) == true
                    }
                }
                
                context("and timer is periodic") {
                    it("should properly reschedule timer on wake up event") {
                        let events = runSimulation(dueTime: .seconds(50),
                                                   period: .seconds(100),
                                                   suspendTimeRange: nil,
                                                   wakeUpTimes: [225, 275, 325])
                        
                        expect(events.count) == 8
                        
                        expect(events.first?.time) == 250
                        expect(events.first?.value.isNext) == true
                        
                        expect(events.second?.time) == 350
                        expect(events.second?.value.isNext) == true
                        
                        expect(events.third?.time) == 450
                        expect(events.third?.value.isNext) == true
                    }
                    
                    context("and event was emitted before due time") {
                        it("should emit missed event after suspension finish on wake up event and properly reschedule timer") {
                            let events = runSimulation(dueTime: .seconds(100),
                                                       period: .seconds(300),
                                                       suspendTimeRange: 50..<200,
                                                       wakeUpTimes: [400])
                            
                            expect(events.count) == 3
                            
                            expect(events.first?.time) == 400 + kObserveOnDelay
                            expect(events.first?.value.isNext) == true
                            
                            expect(events.second?.time) == 600
                            expect(events.second?.value.isNext) == true
                            
                            expect(events.third?.time) == 900
                            expect(events.third?.value.isNext) == true
                        }
                    }
                    
                    context("and repeated event was emitted during suspension") {
                        it("should emit missed event after suspension finish on wake up event and properly reschedule timer") {
                            let events = runSimulation(dueTime: .seconds(2),
                                                       period: .seconds(300),
                                                       suspendTimeRange: 300..<600,
                                                       wakeUpTimes: [600])
                            
                            expect(events.count) == 3
                            
                            expect(events.first?.time) == 202
                            expect(events.first?.value.isNext) == true
                            
                            expect(events.second?.time) == 600 + kObserveOnDelay
                            expect(events.second?.value.isNext) == true
                            
                            expect(events.third?.time) == 802 // 200 + 2 + 2*300
                            expect(events.third?.value.isNext) == true
                        }
                    }
                }
            }
        }
    }
}

fileprivate func runSimulation(dueTime: RxTimeInterval,
                               period: RxTimeInterval?,
                               suspendTimeRange: Range<Int>?,
                               wakeUpTimes: [Int]) -> [Recorded<Event<Void>>] {
    
    let scheduler = TestScheduler(initialClock: 0)
    
    let possiblyWakedUp = scheduler
        .createHotObservable(wakeUpTimes.map { wakeUpTime in
        .init(time: wakeUpTime, value: .next(()))
        })
        .asObservable()
    
    let suspendEvents: [Recorded<Event<Bool>>]
    if let suspendTimeRange = suspendTimeRange {
        suspendEvents = [
            .init(time: 0, value: .next(false)),
            .init(time: suspendTimeRange.startIndex, value: .next(true)),
            .init(time: suspendTimeRange.endIndex, value: .next(false))
        ]
        
    } else {
        suspendEvents = [.init(time: 0, value: .next(false))]
    }
    
    let isAppSuspended = scheduler
        .createColdObservable(suspendEvents)
        .asObservable()
    
    let observer = scheduler.start {
        Observable<Void>
            .backgroundSafeTimer(dueTime,
                                 period: period,
                                 scheduler: scheduler,
                                 possiblyWakedUp: possiblyWakedUp,
                                 timerScheduler: { dueTime, period, scheduler in
                Observable<Int>.timer(dueTime,
                                      period: period,
                                      scheduler: scheduler)
                    .pausableBuffered(isAppSuspended.not(),
                                      limit: 0,
                                      flushOnCompleted: false,
                                      flushOnError: false)
            })
    }
    
    return observer.events
}
