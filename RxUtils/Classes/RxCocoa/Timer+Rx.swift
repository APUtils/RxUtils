//
//  Timer+Rx.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 8/16/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

@available(iOS 10.0, *)
public extension Reactive where Base: Timer {
    /// Creates and returns a Timer observable. Timer scheduled on the current run loop in the default mode.
    /// - parameter timeInterval: The number of seconds between firings of the timer. If seconds is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead
    /// - parameter repeats: If `true`, the timer will repeatedly reschedule itself until invalidated. If `false`, the timer will be invalidated after it fires.
    static func scheduledTimer(withTimeInterval timeInterval: TimeInterval, repeats: Bool) -> Observable<Timer> {
        return Observable.create { observer -> Disposable in
            let timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: repeats) { timer in
                observer.onNext(timer)
                
                if !repeats {
                    observer.onCompleted()
                }
            }
            
            return Disposables.create {
                timer.invalidate()
            }
        }
    }
}
