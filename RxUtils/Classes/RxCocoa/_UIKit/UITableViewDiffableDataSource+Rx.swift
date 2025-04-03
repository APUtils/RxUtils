//
//  UITableViewDiffableDataSource+Rx.swift
//  Pods
//
//  Created by Anton Plebanovich on 5.05.24.
//  Copyright © 2024 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import RoutableLogger

@available(iOS 13.0, tvOS 13.0, *)
public extension UITableViewDiffableDataSource {
    struct Rx { let base: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> }
    var rx: Rx { Rx(base: self) }
}

@available(iOS 13.0, tvOS 13.0, *)
public extension UITableViewDiffableDataSource.Rx {
    func apply(
        _ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
        animatingDifferences: Bool = true,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) -> Single<Void> {
        
        Single.create { observer in
            let date = Date()
            
            base.apply(snapshot, animatingDifferences: animatingDifferences) {
                let computationTime = Date().timeIntervalSince(date)
                RoutableLogger.logVerbose("Differences apply time: \(computationTime)")
                
                if computationTime > 1 {
                    RoutableLogger.logErrorOnce("Huge differences apply time", data: ["computationTime": computationTime], file: file, function: function, line: line)
                }
                
                observer(.success(()))
            }
            
            return Disposables.create()
        }
    }
}
