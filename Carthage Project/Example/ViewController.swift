//
//  ViewController.swift
//  RxUtils-Example
//
//  Created by Anton Plebanovich on 4/12/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import UIKit
import RxUtils
import RxSwift
import RxRelay

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.just(())
            .doOnNext { }
            .subscribe()
            .disposed(by: disposeBag)
    }
}
