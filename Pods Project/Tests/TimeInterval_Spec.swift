//
//  TimeInterval_Spec.swift
//  RxUtils
//
//  Created by Anton Plebanovich on 10.09.24.
//  Copyright © 2024 Anton Plebanovich. All rights reserved.
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

final class TimeInterval_Spec: QuickSpec {
    
    override static func spec() {
        describe("asRxTimeInterval") {
            it("should work properly") {
                expect(Double.infinity.asRxTimeInterval) == .never
                expect((-Double.infinity).asRxTimeInterval) == .never
                expect(Double.nan.asRxTimeInterval) == .never
                expect(Double.signalingNaN.asRxTimeInterval) == .never
                expect(Double.greatestFiniteMagnitude.asRxTimeInterval) == .never
                expect((-Double.greatestFiniteMagnitude).asRxTimeInterval) == .never
                expect(Double.pi.asRxTimeInterval) == .nanoseconds(Int(Double.pi * 1_000_000_000))
            }
        }
    }
}
