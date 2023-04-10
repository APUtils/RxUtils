//
//  EventsProcessor.swift
//  Pods
//
//  Created by Anton Plebanovich on 30.07.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

/// Class that prevents reentrancy anomaly by buffering and processing events one after another.
/// - Tag: EventsProcessor
public final class EventsProcessor<V> {
    
    fileprivate var events: [V] = []
    fileprivate let publishRelay = PublishRelay<V>()
    fileprivate let recursiveLock = NSRecursiveLock()
    
    public init() {}
    
    public func addEvent(_ event: V) {
        recursiveLock.lock(); defer { recursiveLock.unlock() }
        
        let processImmediately = events.isEmpty
        events.append(event)
        
        if processImmediately {
            while let first = events.first {
                publishRelay.accept(first)
                events.removeFirst()
            }
        }
    }
}

// ******************************* MARK: - ObservableObserverType

extension EventsProcessor: ObservableObserverType {
    
    public typealias Element = V
    
    public func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer: ObserverType, Element == Observer.Element {
        publishRelay.subscribe(observer)
    }
    
    public func on(_ event: Event<V>) {
        switch event {
        case .next(let element): publishRelay.accept(element)
        default: return
        }
    }
}
