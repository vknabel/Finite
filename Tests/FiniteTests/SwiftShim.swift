//
//  SwiftShim.swift
//  FiniteTests
//
//  Created by Valentin Knabel on 07.11.17.
//

import XCTest

#if !swift(>=4.0)

    func XCTAssertNoThrow<T>(_ expression: @autoclosure () throws -> T, _ message: @autoclosure () -> String = "XCTAssertNoThrow", file: StaticString = #file, line: UInt = #line) {
        do {
            _ = try expression()
        } catch {
            XCTFail(message(), file: file, line: line)
        }
    }

#endif
