//
//  FiniteTests.swift
//  Finite
//
//  Created by Valentin Knabel on 2016-09-26.
//
//

import XCTest

#if os(macOS)
public typealias XCTestCaseClosure = (XCTestCase) throws -> Void
public typealias XCTestCaseEntry = (testCaseClass: XCTestCase.Type, allTests: [(String, XCTestCaseClosure)])

public func testCase<T: XCTestCase>(_ allTests: [(String, (T) -> () -> Void)]) -> XCTestCaseEntry {
    return (T.self, [])
}
#endif

public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TransitionTests.allTests),
        testCase(StateFlowTests.allTests),
        testCase(StateMachineTests.allTests),
    ]
}
