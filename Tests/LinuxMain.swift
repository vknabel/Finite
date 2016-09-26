import XCTest
@testable import Finite
import FiniteTests

var tests = [XCTestCaseEntry]()
tests += FiniteTests.allTests()
XCTMain(tests)
