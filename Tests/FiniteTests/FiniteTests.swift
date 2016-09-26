//
//  FiniteTests.swift
//  Finite
//
//  Created by Valentin Knabel on 2016-09-26.
//
//

import XCTest

protocol LinuxTestCase {
    associatedtype TestCase: XCTestCase
    static var allTests: [(String, (TestCase) -> () -> ())] { get }
}

#if os(Linux)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TransitionTests.allTests)
    ]
}
#endif
