//
//  Assert.swift
//  Pods
//
//  Created by Anton Plebanovich on 20.11.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

import APExtensions
import Dispatch
import RxSwift

// ******************************* MARK: - Maybe

public extension PrimitiveSequence where Trait == CompletableTrait, Element == Never {
    
    /// Reports error if thread isn't main and throws an exception for DEBUG builds.
    func assertMainThread(
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Completable {
        
        self.do(onError: { error in
            DispatchQueue.assertMainThread(hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        }, onCompleted: {
            DispatchQueue.assertMainThread(hint: "\(hint())onCompleted", file: file, function: function, line: line)
        }, onSubscribe: {
            DispatchQueue.assertMainThread(hint: "\(hint())onSubscribe", file: file, function: function, line: line)
        }, onDispose: {
            DispatchQueue.assertMainThread(hint: "\(hint())onDispose", file: file, function: function, line: line)
        })
    }
    
    /// Reports error if thread isn't main for events processing and throws an exception for DEBUG builds.
    func assertMainThreadForEvents(
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Completable {
        
        self.do(onError: { error in
            DispatchQueue.assertMainThread(hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        })
    }
    
    /// Reports error if queue isn't main and throws an exception for DEBUG builds.
    func assertMainQueue(
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Completable {
        
        self.do(onError: { error in
            DispatchQueue.assertMainQueue(hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        }, onCompleted: {
            DispatchQueue.assertMainQueue(hint: "\(hint())onCompleted", file: file, function: function, line: line)
        }, onSubscribe: {
            DispatchQueue.assertMainQueue(hint: "\(hint())onSubscribe", file: file, function: function, line: line)
        }, onDispose: {
            DispatchQueue.assertMainQueue(hint: "\(hint())onDispose", file: file, function: function, line: line)
        })
    }
    
    /// Reports error if executes on a different queue and throws an exception for DEBUG builds.
    /// - note: You must preventively assign non-nil value for a `key` you are passing.
    func assertQueue<T>(
        key: DispatchSpecificKey<T>?,
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Completable {
        
        guard let key else { return self }
        
        return self.do(onError: { error in
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        }, onCompleted: {
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onCompleted", file: file, function: function, line: line)
        }, onSubscribe: {
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onSubscribe", file: file, function: function, line: line)
        }, onDispose: {
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onDispose", file: file, function: function, line: line)
        })
    }
    
    /// Reports error for events processing on a different queue and throws an exception for DEBUG builds.
    /// - note: You must preventively assign non-nil value for a `key` you are passing.
    func assertQueueForEvents<T>(
        key: DispatchSpecificKey<T>?,
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Completable {
        
        guard let key else { return self }
        
        return self.do(onError: { error in
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        })
    }
}

// ******************************* MARK: - ObservableType

public extension ObservableType {
    
    /// Reports error if thread isn't main and throws an exception for DEBUG builds.
    func assertMainThread(
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Observable<Element> {
        
        self.do(onNext: { element in
            DispatchQueue.assertMainThread(hint: "\(hint())onNext(\(element))", file: file, function: function, line: line)
        }, onError: { error in
            DispatchQueue.assertMainThread(hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        }, onCompleted: {
            DispatchQueue.assertMainThread(hint: "\(hint())onCompleted", file: file, function: function, line: line)
        }, onSubscribe: {
            DispatchQueue.assertMainThread(hint: "\(hint())onSubscribe", file: file, function: function, line: line)
        }, onDispose: {
            DispatchQueue.assertMainThread(hint: "\(hint())onDispose", file: file, function: function, line: line)
        })
    }
    
    /// Reports error if thread isn't main for events processing and throws an exception for DEBUG builds.
    func assertMainThreadForEvents(
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Observable<Element> {
        
        self.do(onNext: { element in
            DispatchQueue.assertMainThread(hint: "\(hint())onNext(\(element))", file: file, function: function, line: line)
        }, onError: { error in
            DispatchQueue.assertMainThread(hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        }, onCompleted: {
            DispatchQueue.assertMainThread(hint: "\(hint())onCompleted", file: file, function: function, line: line)
        })
    }
    
    /// Reports error if queue isn't main and throws an exception for DEBUG builds.
    func assertMainQueue(
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Observable<Element> {
        
        self.do(onNext: { element in
            DispatchQueue.assertMainQueue(hint: "\(hint())onNext(\(element))", file: file, function: function, line: line)
        }, onError: { error in
            DispatchQueue.assertMainQueue(hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        }, onCompleted: {
            DispatchQueue.assertMainQueue(hint: "\(hint())onCompleted", file: file, function: function, line: line)
        }, onSubscribe: {
            DispatchQueue.assertMainQueue(hint: "\(hint())onSubscribe", file: file, function: function, line: line)
        }, onDispose: {
            DispatchQueue.assertMainQueue(hint: "\(hint())onDispose", file: file, function: function, line: line)
        })
    }
    
    /// Reports error if executes on a different queue and throws an exception for DEBUG builds.
    /// - note: You must preventively assign non-nil value for a `key` you are passing.
    func assertQueue<T>(
        key: DispatchSpecificKey<T>?,
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Observable<Element> {
        
        guard let key else { return asObservable() }
        
        return self.do(onNext: { element in
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onNext(\(element))", file: file, function: function, line: line)
        }, onError: { error in
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        }, onCompleted: {
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onCompleted", file: file, function: function, line: line)
        }, onSubscribe: {
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onSubscribe", file: file, function: function, line: line)
        }, onDispose: {
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onDispose", file: file, function: function, line: line)
        })
    }
    
    /// Reports error for events processing on a different queue and throws an exception for DEBUG builds.
    /// - note: You must preventively assign non-nil value for a `key` you are passing.
    func assertQueueForEvents<T>(
        key: DispatchSpecificKey<T>?,
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Observable<Element> {
        
        guard let key else { return asObservable() }
        
        return self.do(onNext: { element in
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onNext(\(element))", file: file, function: function, line: line)
        }, onError: { error in
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        }, onCompleted: {
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onCompleted", file: file, function: function, line: line)
        })
    }
}

// ******************************* MARK: - Maybe

public extension PrimitiveSequence where Trait == MaybeTrait {
    
    /// Reports error if thread isn't main and throws an exception for DEBUG builds.
    func assertMainThread(
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Maybe<Element> {
        
        self.do(onNext: { element in
            DispatchQueue.assertMainThread(hint: "\(hint())onNext(\(element))", file: file, function: function, line: line)
        }, onError: { error in
            DispatchQueue.assertMainThread(hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        }, onCompleted: {
            DispatchQueue.assertMainThread(hint: "\(hint())onCompleted", file: file, function: function, line: line)
        }, onSubscribe: {
            DispatchQueue.assertMainThread(hint: "\(hint())onSubscribe", file: file, function: function, line: line)
        }, onDispose: {
            DispatchQueue.assertMainThread(hint: "\(hint())onDispose", file: file, function: function, line: line)
        })
    }
    
    /// Reports error if thread isn't main for events processing and throws an exception for DEBUG builds.
    func assertMainThreadForEvents(
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Maybe<Element> {
        
        self.do(onNext: { element in
            DispatchQueue.assertMainThread(hint: "\(hint())onNext(\(element))", file: file, function: function, line: line)
        }, onError: { error in
            DispatchQueue.assertMainThread(hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        })
    }
    
    /// Reports error if queue isn't main and throws an exception for DEBUG builds.
    func assertMainQueue(
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Maybe<Element> {
        
        self.do(onNext: { element in
            DispatchQueue.assertMainQueue(hint: "\(hint())onNext(\(element))", file: file, function: function, line: line)
        }, onError: { error in
            DispatchQueue.assertMainQueue(hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        }, onCompleted: {
            DispatchQueue.assertMainQueue(hint: "\(hint())onCompleted", file: file, function: function, line: line)
        }, onSubscribe: {
            DispatchQueue.assertMainQueue(hint: "\(hint())onSubscribe", file: file, function: function, line: line)
        }, onDispose: {
            DispatchQueue.assertMainQueue(hint: "\(hint())onDispose", file: file, function: function, line: line)
        })
    }
    
    /// Reports error if executes on a different queue and throws an exception for DEBUG builds.
    /// - note: You must preventively assign non-nil value for a `key` you are passing.
    func assertQueue<T>(
        key: DispatchSpecificKey<T>?,
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Maybe<Element> {
        
        guard let key else { return self }
        
        return self.do(onNext: { element in
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onNext(\(element))", file: file, function: function, line: line)
        }, onError: { error in
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        }, onCompleted: {
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onCompleted", file: file, function: function, line: line)
        }, onSubscribe: {
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onSubscribe", file: file, function: function, line: line)
        }, onDispose: {
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onDispose", file: file, function: function, line: line)
        })
    }
    
    /// Reports error for events processing on a different queue and throws an exception for DEBUG builds.
    /// - note: You must preventively assign non-nil value for a `key` you are passing.
    func assertQueueForEvents<T>(
        key: DispatchSpecificKey<T>?,
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Maybe<Element> {
        
        guard let key else { return self }
        
        return self.do(onNext: { element in
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onNext(\(element))", file: file, function: function, line: line)
        }, onError: { error in
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        })
    }
}

// ******************************* MARK: - Single

public extension PrimitiveSequence where Trait == SingleTrait {
    
    /// Reports error if thread isn't main and throws an exception for DEBUG builds.
    func assertMainThread(
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Single<Element> {
        
        self.do(onSuccess: { element in
            DispatchQueue.assertMainThread(hint: "\(hint())onSuccess(\(element))", file: file, function: function, line: line)
        }, onError: { error in
            DispatchQueue.assertMainThread(hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        }, onSubscribe: {
            DispatchQueue.assertMainThread(hint: "\(hint())onSubscribe", file: file, function: function, line: line)
        }, onDispose: {
            DispatchQueue.assertMainThread(hint: "\(hint())onDispose", file: file, function: function, line: line)
        })
    }
    
    /// Reports error if thread isn't main for events processing and throws an exception for DEBUG builds.
    func assertMainThreadForEvents(
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Single<Element> {
        
        self.do(onSuccess: { element in
            DispatchQueue.assertMainThread(hint: "\(hint())onSuccess(\(element))", file: file, function: function, line: line)
        }, onError: { error in
            DispatchQueue.assertMainThread(hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        })
    }
    
    /// Reports error if queue isn't main and throws an exception for DEBUG builds.
    func assertMainQueue(
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Single<Element> {
        
        self.do(onSuccess: { element in
            DispatchQueue.assertMainQueue(hint: "\(hint())onSuccess(\(element))", file: file, function: function, line: line)
        }, onError: { error in
            DispatchQueue.assertMainQueue(hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        }, onSubscribe: {
            DispatchQueue.assertMainQueue(hint: "\(hint())onSubscribe", file: file, function: function, line: line)
        }, onDispose: {
            DispatchQueue.assertMainQueue(hint: "\(hint())onDispose", file: file, function: function, line: line)
        })
    }
    
    /// Reports error if executes on a different queue and throws an exception for DEBUG builds.
    /// - note: You must preventively assign non-nil value for a `key` you are passing.
    func assertQueue<T>(
        key: DispatchSpecificKey<T>?,
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Single<Element> {
        
        guard let key else { return self }
        
        return self.do(onSuccess: { element in
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onSuccess(\(element))", file: file, function: function, line: line)
        }, onError: { error in
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        }, onSubscribe: {
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onSubscribe", file: file, function: function, line: line)
        }, onDispose: {
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onDispose", file: file, function: function, line: line)
        })
    }
    
    /// Reports error for events processing on a different queue and throws an exception for DEBUG builds.
    /// - note: You must preventively assign non-nil value for a `key` you are passing.
    func assertQueueForEvents<T>(
        key: DispatchSpecificKey<T>?,
        hint: @autoclosure @escaping () -> String = "",
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Single<Element> {
        
        guard let key else { return self }
        
        return self.do(onSuccess: { element in
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onSuccess(\(element))", file: file, function: function, line: line)
        }, onError: { error in
            DispatchQueue.assertQueue(key: key, hint: "\(hint())onError(\(error))", file: file, function: function, line: line)
        })
    }
}
