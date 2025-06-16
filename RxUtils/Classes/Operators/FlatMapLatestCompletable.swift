//
//  FlatMapLatestCompletable.swift
//  Pods
//
//  Created by Anton Plebanovich on 16.06.25.
//  Copyright © 2025 Anton Plebanovich. All rights reserved.
//

import RxSwift

// ******************************* MARK: - ObservableConvertibleType

public extension ObservableConvertibleType {
    
    func flatMapLatestCompletable(_ selector: @escaping (Element) throws -> Completable) -> Completable {
        asObservable()
            .flatMapLatest(selector)
            .asCompletable()
    }
}
