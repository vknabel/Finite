//
//  StateFlowTests.swift
//  FiniteTests
//
//  Created by Valentin Knabel on 06.11.17.
//

import XCTest
import Finite

class StateFlowTests: XCTestCase {
    static var allTests = [
        ("testAllowsAbsoluteTransitionsWhenAddedPreviously", testAllowsAbsoluteTransitionsWhenAddedPreviously),
        ("testDoesNotAllowTransitionsToSameStateByDefault", testDoesNotAllowTransitionsToSameStateByDefault),
        ("testDoesNotAllowUnrelatedAbsoluteTransitions", testDoesNotAllowUnrelatedAbsoluteTransitions),
        ("testAllowsFromRelativeTransitionsWhenAddedPreviously", testAllowsFromRelativeTransitionsWhenAddedPreviously),
        ("testAllowsToRelativeTransitionsWhenAddedPreviously", testAllowsToRelativeTransitionsWhenAddedPreviously),
        ("testDoesNotAllowNilTransitionsWhenAddedPreviously", testDoesNotAllowNilTransitionsWhenAddedPreviously),
        ("testAllowsAbsoluteTransitionWhenFromRelativeIsAllowed", testAllowsAbsoluteTransitionWhenFromRelativeIsAllowed),
        ("testAllowsAbsoluteTransitionWhenToRelativeIsAllowed", testAllowsAbsoluteTransitionWhenToRelativeIsAllowed),
        ("testDoesNotAllowAbsoluteTransitionsWhenAddedNilPreviously", testDoesNotAllowAbsoluteTransitionsWhenAddedNilPreviously)
    ]
    
    enum Test {
        case s0, s1, s2
    }

    var sut: StateFlow<Test>!

    override func setUp() {
        sut = nil
    }

    func testAllowsAbsoluteTransitionsWhenAddedPreviously() {
        let transition = Transition<Test>(from: .s0, to: .s1)
        prepare(allowing: transition)
        XCTAssertTrue(sut.allows(transition))
    }

    func testDoesNotAllowTransitionsToSameStateByDefault() {
        prepare()
        let transition = Transition<Test>(from: .s0, to: .s0)
        XCTAssertFalse(sut.allows(transition))
    }

    func testDoesNotAllowUnrelatedAbsoluteTransitions() {
        let transition = Transition<Test>(from: .s0, to: .s1)
        prepare(allowing: transition)
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s2)))
    }

    func testAllowsFromRelativeTransitionsWhenAddedPreviously() {
        let transition = Transition<Test>(from: nil, to: .s1)
        prepare(allowing: transition)
        XCTAssertTrue(sut.allows(transition))
    }

    func testAllowsToRelativeTransitionsWhenAddedPreviously() {
        let transition = Transition<Test>(from: .s0, to: nil)
        prepare(allowing: transition)
        XCTAssertTrue(sut.allows(transition))
    }

    func testDoesNotAllowNilTransitionsWhenAddedPreviously() {
        let transition = Transition<Test>.nilTransition
        prepare(allowing: transition)
        XCTAssertFalse(sut.allows(transition))
    }

    func testAllowsAbsoluteTransitionWhenFromRelativeIsAllowed() {
        prepare(allowing: Transition(from: nil, to: .s1))
        XCTAssertTrue(sut.allows(Transition(from: .s0, to: .s1)))
    }

    func testAllowsAbsoluteTransitionWhenToRelativeIsAllowed() {
        prepare(allowing: Transition(from: .s0, to: nil))
        XCTAssertTrue(sut.allows(Transition(from: .s0, to: .s1)))
    }

    func testDoesNotAllowAbsoluteTransitionsWhenAddedNilPreviously() {
        prepare(allowing: .nilTransition)
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s1)))
    }

    private func prepare(allowing transitions: Transition<Test>...) {
        sut = StateFlow<Test> { flow in
            for t in transitions {
                flow.allow(transition: t)
            }
        }
    }
}
