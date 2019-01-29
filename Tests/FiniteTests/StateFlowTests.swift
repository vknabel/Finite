//
//  StateFlowTests.swift
//  FiniteTests
//
//  Created by Valentin Knabel on 06.11.17.
//

import Finite
import XCTest

class StateFlowTests: XCTestCase {
    static var allTests = [
        ("testEmptyDeniesEverything", testEmptyDeniesEverything),
        ("testEmptyDeniesEverythingForConfig", testEmptyDeniesEverythingForConfig),
        ("testAllowsAbsoluteTransitionsWhenAddedPreviously", testAllowsAbsoluteTransitionsWhenAddedPreviously),
        ("testAllowsAbsoluteTransitionsWhenAddedPreviouslyUsingEmptyInitializer", testAllowsAbsoluteTransitionsWhenAddedPreviouslyUsingEmptyInitializer),
        ("testDoesNotAllowTransitionsToSameStateByDefault", testDoesNotAllowTransitionsToSameStateByDefault),
        ("testDoesNotAllowUnrelatedAbsoluteTransitions", testDoesNotAllowUnrelatedAbsoluteTransitions),
        ("testAllowsFromRelativeTransitionsWhenAddedPreviously", testAllowsFromRelativeTransitionsWhenAddedPreviously),
        ("testAllowsToRelativeTransitionsWhenAddedPreviously", testAllowsToRelativeTransitionsWhenAddedPreviously),
        ("testDoesNotAllowNilTransitionsWhenAddedPreviously", testDoesNotAllowNilTransitionsWhenAddedPreviously),
        ("testAllowsAbsoluteTransitionWhenFromRelativeIsAllowed", testAllowsAbsoluteTransitionWhenFromRelativeIsAllowed),
        ("testAllowsAbsoluteTransitionWhenToRelativeIsAllowed", testAllowsAbsoluteTransitionWhenToRelativeIsAllowed),
        ("testDoesNotAllowAbsoluteTransitionsWhenAddedNilPreviously", testDoesNotAllowAbsoluteTransitionsWhenAddedNilPreviously),
        ("testAllowsAlwaysSucceedingFilter", testAllowsAlwaysSucceedingFilter),
        ("testDeniesAlwaysDenyingFilter", testDeniesAlwaysDenyingFilter),
        ("testDescriptionWithContents", testDescriptionWithContents),
        ("testDescriptionWithoutContents", testDescriptionWithoutContents),
        ("testAllowingConvenienceFromRelativeTransitionHelper", testAllowingConvenienceFromRelativeTransitionHelper),
        ("testAllowingMultipleConvenienceFromRelativeTransitionHelper", testAllowingMultipleConvenienceFromRelativeTransitionHelper),
        ("testAllowingConvenienceToRelativeTransitionHelper", testAllowingConvenienceToRelativeTransitionHelper),
        ("testAllowingMultipleConvenienceToRelativeTransitionHelper", testAllowingMultipleConvenienceToRelativeTransitionHelper),
        ("testAllowingMultipleConvenienceFromAbsoluteTransitionHelper", testAllowingMultipleConvenienceFromAbsoluteTransitionHelper),
        ("testAllowingMultipleConvenienceToAbsoluteTransitionHelper", testAllowingMultipleConvenienceToAbsoluteTransitionHelper),
        ("testAllowingMultipleConvenienceFromToAbsoluteTransitionHelper", testAllowingMultipleConvenienceFromToAbsoluteTransitionHelper),
        ("testAllowingEverythingMultipleConvenienceFromToAbsoluteTransitionHelperForEveryState", testAllowingEverythingMultipleConvenienceFromToAbsoluteTransitionHelperForEveryState)
    ]

    enum Test {
        case s0, s1, s2
    }

    var sut: StateFlow<Test>!

    override func setUp() {
        sut = nil
    }

    func testEmptyDeniesEverything() {
        sut = StateFlow()
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s2)))

        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s2)))

        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s2)))
    }

    func testEmptyDeniesEverythingForConfig() {
        prepare()
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s2)))

        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s2)))

        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s2)))
    }

    func testAllowsAbsoluteTransitionsWhenAddedPreviously() {
        let transition = Transition<Test>(from: .s0, to: .s1)
        prepare(allowing: transition)
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s0)))
        XCTAssertTrue(sut.allows(Transition(from: .s0, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s2)))

        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s2)))

        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s2)))
    }

    func testAllowsAbsoluteTransitionsWhenAddedPreviouslyUsingEmptyInitializer() {
        let transition = Transition<Test>(from: .s0, to: .s1)
        sut = StateFlow()
        sut.allow(transition: transition)

        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s0)))
        XCTAssertTrue(sut.allows(Transition(from: .s0, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s2)))

        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s2)))

        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s2)))
    }

    func testDoesNotAllowTransitionsToSameStateByDefault() {
        prepare()
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s2)))

        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s2)))

        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s2)))
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

    func testAllowsAlwaysSucceedingFilter() {
        sut = StateFlow()
        sut.allow(from: .s0) { _ in true }
        XCTAssertTrue(sut.allows(Transition(from: .s0, to: .s1)))
        XCTAssertTrue(sut.allows(Transition(from: .s0, to: .s0)))
    }

    func testDeniesAlwaysDenyingFilter() {
        sut = StateFlow()
        sut.allow(from: .s0) { _ in false }
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s2)))
    }

    func testDescriptionWithContents() {
        sut = StateFlow()
        sut.allow(from: [.s0, .s1])
        sut.allow(from: .s1, to: .s2)
        XCTAssertEqual(Set(sut.description.split(separator: "\n").map(String.init)), [
            Transition<Test>(from: .s0, to: nil).description,
            Transition<Test>(from: .s1, to: nil).description,
            Transition<Test>(from: .s1, to: .s2).description
        ])
    }

    func testDescriptionWithoutContents() {
        sut = StateFlow()
        XCTAssertEqual(sut.description, "")
    }

    func testAllowingConvenienceFromRelativeTransitionHelper() {
        sut = StateFlow()
        sut.allow(from: .s2)
        XCTAssertTrue(sut.allows(Transition(from: .s2, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s1)))
    }

    func testAllowingMultipleConvenienceFromRelativeTransitionHelper() {
        sut = StateFlow()
        sut.allow(from: [.s1, .s2])
        XCTAssertTrue(sut.allows(Transition(from: .s2, to: .s1)))
        XCTAssertTrue(sut.allows(Transition(from: .s1, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s1)))
    }

    func testAllowingConvenienceToRelativeTransitionHelper() {
        sut = StateFlow()
        sut.allow(to: .s2)
        XCTAssertTrue(sut.allows(Transition(from: .s0, to: .s2)))
        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s0)))
    }

    func testAllowingMultipleConvenienceToRelativeTransitionHelper() {
        sut = StateFlow()
        sut.allow(to: [.s1, .s2])
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s0)))
        XCTAssertTrue(sut.allows(Transition(from: .s0, to: .s1)))
        XCTAssertTrue(sut.allows(Transition(from: .s0, to: .s2)))

        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s0)))
        XCTAssertTrue(sut.allows(Transition(from: .s1, to: .s1)))
        XCTAssertTrue(sut.allows(Transition(from: .s1, to: .s2)))

        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s0)))
        XCTAssertTrue(sut.allows(Transition(from: .s2, to: .s1)))
        XCTAssertTrue(sut.allows(Transition(from: .s2, to: .s2)))
    }

    func testAllowingMultipleConvenienceFromAbsoluteTransitionHelper() {
        sut = StateFlow()
        sut.allow(from: [.s0, .s1], to: .s2)
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s1)))
        XCTAssertTrue(sut.allows(Transition(from: .s0, to: .s2)))

        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s1)))
        XCTAssertTrue(sut.allows(Transition(from: .s1, to: .s2)))

        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s2)))
    }

    func testAllowingMultipleConvenienceToAbsoluteTransitionHelper() {
        sut = StateFlow()
        sut.allow(from: .s0, to: [.s1, .s2])
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s0)))
        XCTAssertTrue(sut.allows(Transition(from: .s0, to: .s1)))
        XCTAssertTrue(sut.allows(Transition(from: .s0, to: .s2)))

        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s2)))

        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s2)))
    }

    func testAllowingMultipleConvenienceFromToAbsoluteTransitionHelper() {
        sut = StateFlow()
        sut.allow(from: [.s0, .s1], to: [.s1, .s2])
        XCTAssertFalse(sut.allows(Transition(from: .s0, to: .s0)))
        XCTAssertTrue(sut.allows(Transition(from: .s0, to: .s1)))
        XCTAssertTrue(sut.allows(Transition(from: .s0, to: .s2)))

        XCTAssertFalse(sut.allows(Transition(from: .s1, to: .s0)))
        XCTAssertTrue(sut.allows(Transition(from: .s1, to: .s1)))
        XCTAssertTrue(sut.allows(Transition(from: .s1, to: .s2)))

        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s0)))
        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s1)))
        XCTAssertFalse(sut.allows(Transition(from: .s2, to: .s2)))
    }

    func testAllowingEverythingMultipleConvenienceFromToAbsoluteTransitionHelperForEveryState() {
        sut = StateFlow()
        sut.allow(from: [.s0, .s1, .s2], to: [.s0, .s1, .s2])
        XCTAssertTrue(sut.allows(Transition(from: .s0, to: .s0)))
        XCTAssertTrue(sut.allows(Transition(from: .s0, to: .s1)))
        XCTAssertTrue(sut.allows(Transition(from: .s0, to: .s2)))

        XCTAssertTrue(sut.allows(Transition(from: .s1, to: .s0)))
        XCTAssertTrue(sut.allows(Transition(from: .s1, to: .s1)))
        XCTAssertTrue(sut.allows(Transition(from: .s1, to: .s2)))

        XCTAssertTrue(sut.allows(Transition(from: .s2, to: .s0)))
        XCTAssertTrue(sut.allows(Transition(from: .s2, to: .s1)))
        XCTAssertTrue(sut.allows(Transition(from: .s2, to: .s2)))
    }

    private func prepare(allowing transitions: Transition<Test>...) {
        sut = StateFlow<Test> { flow in
            for t in transitions {
                flow.allow(transition: t)
            }
        }
    }
}
