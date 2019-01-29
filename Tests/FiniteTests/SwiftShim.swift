//
//  SwiftShim.swift
//  FiniteTests
//
//  Created by Valentin Knabel on 07.11.17.
//

import XCTest

#if os(macOS)
    public typealias XCTestCaseClosure = (XCTestCase) throws -> Void
    public typealias XCTestCaseEntry = (testCaseClass: XCTestCase.Type, allTests: [(String, XCTestCaseClosure)])

    public func testCase<T: XCTestCase>(_: [(String, (T) -> () -> Void)]) -> XCTestCaseEntry {
        return (T.self, [])
    }

#endif

public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TransitionTests.allTests),
        testCase(StateFlowTests.allTests),
        testCase(StateMachineTests.allTests)
    ]
}

#if !swift(>=4.0)

    func XCTAssertNoThrow<T>(_ expression: @autoclosure () throws -> T, _ message: @autoclosure () -> String = "XCTAssertNoThrow", file: StaticString = #file, line: UInt = #line) {
        do {
            _ = try expression()
        } catch {
            XCTFail(message(), file: file, line: line)
        }
    }

#endif
