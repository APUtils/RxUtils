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
    
    private let pauser = BehaviorRelay(value: false)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Single.just(())
            .pausableBuffered(pauser)
            .debug()
            .subscribe()
            .disposed(by: disposeBag)
    }
}
