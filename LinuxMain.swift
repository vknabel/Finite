import XCTest

import FiniteTests

var tests = [XCTestCaseEntry]()
tests += FiniteTests.__allTests()

XCTMain(tests)
