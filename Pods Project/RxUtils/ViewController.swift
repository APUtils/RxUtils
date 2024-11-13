//
//  ViewController.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 04/12/2019.
//  Copyright (c) 2019 Anton Plebanovich. All rights reserved.
//

import UIKit
import RxUtils
import RxSwift
import RxRelay

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkKeychain()
        checkFlatMapThrottle()
        
        _ = Single.just(1).flatMapCompletable { _ in return .empty() }
        _ = Maybe.just(1).flatMapCompletable { _ in return .empty() }
    }
    
    private func checkKeychain() {
        UIApplication.shared.rx
            .isKeychainReadable
            .debug("isKeychainReadable")
            .subscribe()
            .disposed(by: disposeBag)
        
        UIApplication.shared.rx
            .isProtectedDataAvailable
            .debug("isProtectedDataAvailable")
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func checkFlatMapThrottle() {
        let processingQueue = DispatchQueue(label: "RxUtils.processing", qos: .userInteractive)
        let processingScheduler = DispatchQueueScheduler(queue: processingQueue)
        
        let executeQueue = DispatchQueue(label: "RxUtils.execute", qos: .userInteractive)
        let executeScheduler = DispatchQueueScheduler(queue: executeQueue)
        Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: processingScheduler)
            .observe(on: processingScheduler)
            .doOnNext { print("Process - \($0)") }
            .flatMapThrottle(scheduler: executeScheduler) { i -> Single<Int> in
                Single.just(i)
                    .doOnSuccess { print("Execute - \($0).1") }
                    .doOnSuccess { _ in sleep(1) }
                    .doOnSuccess { print("Execute - \($0).2") }
                    .doOnSuccess { _ in sleep(1) }
                    .doOnSuccess { print("Execute - \($0).3") }
                    .doOnSuccess { _ in sleep(1) }
                    .doOnSuccess { print("Execute - \($0).4") }
            }
            .subscribeOnNext {
                print("Finish - \($0)")
            }
            .disposed(by: disposeBag)
    }
    
    @IBAction fileprivate func onShowAlertTap(_ sender: Any) {
//        _ = Single.just(())
//            .showContinueAlert(message: "Are you sure want to continue?")
//            .timeout(.seconds(5), scheduler: ConcurrentMainScheduler.instance)
//            .debug("showContinueAlert")
//            .subscribe()
        
        _ = Single.just(())
            .showOkAlert(message: "Execution will continue")
            .debug("showOkAlert")
            .subscribe()
    }
}
