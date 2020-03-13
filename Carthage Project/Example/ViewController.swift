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

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = Maybe.just(1).mapToVoid()
    }
}
