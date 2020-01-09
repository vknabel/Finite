@testable import Finite
import FiniteTests
import XCTest

var tests = [XCTestCaseEntry]()
tests += FiniteTests.allTests()
XCTMain(tests)
