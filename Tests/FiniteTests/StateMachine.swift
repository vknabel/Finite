//
//  StateMachine.swift
//  FiniteTests
//
//  Created by Valentin Knabel on 06.11.17.
//

import Finite
import XCTest

class StateMachineTests: XCTestCase {
    static var allTests = [
        ("testCreatingStateMachineWillSetState", testCreatingStateMachineWillSetState),
        ("testAllowedTransitionsDoNotThrowAndAdjustTheState", testAllowedTransitionsDoNotThrowAndAdjustTheState),
        ("testNotAllowedTransitionsDoThrowAndKeepTheState", testNotAllowedTransitionsDoThrowAndKeepTheState)
    ]

    enum Test {
        case s0, s1
    }

    var sut: StateMachine<Test>!

    override func setUp() {
        sut = nil
    }

    func testCreatingStateMachineWillSetState() {
        prepare(initial: .s0, allowing: Transition(from: .s0, to: .s1))
        XCTAssertEqual(sut.state, .s0)
    }

    func testAllowedTransitionsDoNotThrowAndAdjustTheState() {
        prepare(allowing: Transition(from: .s0, to: .s1))
        XCTAssertNoThrow(try sut.transition(to: .s1))
        XCTAssertEqual(sut.state, .s1)
    }

    func testNotAllowedTransitionsDoThrowAndKeepTheState() {
        prepare(initial: .s0, allowing: Transition(from: .s0, to: .s1))
        let action = { try self.sut.transition(to: .s0) }
        XCTAssertThrowsError(try action()) { error in
            if case let TransitionError.denied(from: from, to: to) as TransitionError<Test> = error {
                XCTAssertEqual(from, .s0)
                XCTAssertEqual(to, .s0)
            } else {
                XCTFail()
            }
        }
        XCTAssertEqual(sut.state, .s0)
    }

    private func prepare(initial state: Test = .s0, allowing transitions: Transition<Test>...) {
        sut = StateMachine<Test>(initial: state) { flow in
            for t in transitions {
                flow.allow(transition: t)
            }
        }
    }
}
