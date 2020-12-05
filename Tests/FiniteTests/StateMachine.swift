//
//  StateMachine.swift
//  FiniteTests
//
//  Created by Valentin Knabel on 06.11.17.
//

import Finite
import XCTest

class StateMachineTests: XCTestCase {
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
            if case let .denied(from: from, to: to) = error as? TransitionError<Test> {
                XCTAssertEqual(from, .s0)
                XCTAssertEqual(to, .s0)
            } else {
                XCTFail()
            }
        }
        XCTAssertEqual(sut.state, .s0)
    }

    func testOnTransitionsForNilTransitionTriggered() throws {
        prepare(allowing: Transition(from: .s0, to: .s1))
        let calledOnNilTransitions = expectation(description: "onTransitions(like:_:) called")
        sut.onTransitions(like: .nilTransition) {
            calledOnNilTransitions.fulfill()
        }
        let calledOnDefaultTransitions = expectation(description: "onTransitions(_:) called")
        sut.onTransitions {
            calledOnDefaultTransitions.fulfill()
        }
        try sut.transition(to: .s1)
        self.wait(for: [calledOnNilTransitions, calledOnDefaultTransitions], timeout: 0.1)
    }

    func testSubscribeTransitionsForNilTransitionTriggeredWhenHold() throws {
        var disposeBag = [ReferenceDisposable]()
        prepare(allowing: Transition(from: .s0, to: .s1))
        let calledOnNilTransitions = expectation(description: "subscribeTransitions(like:_:) called")
        disposeBag.append(sut.subscribeTransitions(like: .nilTransition) {
            calledOnNilTransitions.fulfill()
        })
        let calledOnDefaultTransitions = expectation(description: "subscribeTransitions(_:) called")
        disposeBag.append(sut.subscribeTransitions {
            calledOnDefaultTransitions.fulfill()
        })
        try sut.transition(to: .s1)
        self.wait(for: [calledOnNilTransitions, calledOnDefaultTransitions], timeout: 0.1)
    }

    func testSubscribeTransitionsForNilTransitionNeverTriggeredWhenNotHold() throws {
        prepare(allowing: Transition(from: .s0, to: .s1))
        let calledOnNilTransitions = expectation(description: "subscribeTransitions(like:_:) called")
        calledOnNilTransitions.isInverted = true
        _ = sut.subscribeTransitions(like: .nilTransition) {
            calledOnNilTransitions.fulfill()
        }
        let calledOnDefaultTransitions = expectation(description: "subscribeTransitions(_:) called")
        calledOnDefaultTransitions.isInverted = true
        _ = sut.subscribeTransitions {
            calledOnDefaultTransitions.fulfill()
        }
        try sut.transition(to: .s1)
        self.wait(for: [calledOnNilTransitions, calledOnDefaultTransitions], timeout: 0.1)
    }

    func testOnTransitionsTriggeredOnExactTransition() throws {
        prepare(allowing: Transition(from: .s0, to: .s1))
        let calledOnTransitions = expectation(description: "onTransitions(like:_:) called")
        sut.onTransitions(like: Transition(from: .s0, to: .s1)) {
            calledOnTransitions.fulfill()
        }
        let calledOnTransitionsTo = expectation(description: "onTransitions(to:_:) called")
        sut.onTransitions(to: .s1) {
            calledOnTransitionsTo.fulfill()
        }
        let calledOnTransitionsFrom = expectation(description: "onTransitions(from:_:) called")
        sut.onTransitions(from: .s0) {
            calledOnTransitionsFrom.fulfill()
        }
        let calledOnTransitionsFromTo = expectation(description: "onTransitions(from:to:_:) called")
        sut.onTransitions(from: .s0, to: .s1) {
            calledOnTransitionsFromTo.fulfill()
        }

        try sut.transition(to: .s1)
        self.wait(for: [calledOnTransitions, calledOnTransitionsTo, calledOnTransitionsFrom, calledOnTransitionsFromTo], timeout: 1)
    }

    func testOnTransitionsNeverTriggeredOnSwappedTransition() throws {
        prepare(allowing: Transition(from: .s0, to: .s1))

        let anyCalled = expectation(description: "any transition called")
        anyCalled.isInverted = true
        sut.onTransitions(like: Transition(from: .s1, to: .s0)) {
            anyCalled.fulfill()
        }
        sut.onTransitions(to: .s0) {
            anyCalled.fulfill()
        }
        sut.onTransitions(from: .s1) {
            anyCalled.fulfill()
        }
        sut.onTransitions(from: .s1, to: .s0) {
            anyCalled.fulfill()
        }

        try sut.transition(to: .s1)
        self.wait(for: [anyCalled], timeout: 0.1)
    }

    func testSubscribedTransitionsTriggeredOnExactTransitionWhenStored() throws {
        var disposeBag = [ReferenceDisposable]()
        prepare(allowing: Transition(from: .s0, to: .s1))
        let calledSubscribeTransitions = expectation(description: "subscribeTransitions(like:_:) called")
        disposeBag.append(sut.subscribeTransitions(like: Transition(from: .s0, to: .s1)) {
            calledSubscribeTransitions.fulfill()
        })
        let calledSubscribeTransitionsTo = expectation(description: "subscribeTransitions(to:_:) called")
        disposeBag.append(sut.subscribeTransitions(to: .s1) {
            calledSubscribeTransitionsTo.fulfill()
        })
        let calledSubscribeTransitionsFrom = expectation(description: "subscribeTransitions(from:_:) called")
        disposeBag.append(sut.subscribeTransitions(from: .s0) {
            calledSubscribeTransitionsFrom.fulfill()
        })
        let calledSubscribeTransitionsFromTo = expectation(description: "subscribeTransitions(from:to:_:) called")
        disposeBag.append(sut.subscribeTransitions(from: .s0, to: .s1) {
            calledSubscribeTransitionsFromTo.fulfill()
        })

        try sut.transition(to: .s1)
        self.wait(for: [calledSubscribeTransitions, calledSubscribeTransitionsTo, calledSubscribeTransitionsFrom, calledSubscribeTransitionsFromTo], timeout: 0.1)
    }

    func testSubscribedTransitionsNeverTriggeredOnExactTransitionWhenNotStored() throws {
        prepare(allowing: Transition(from: .s0, to: .s1))
        let anyCalled = expectation(description: "any subscribeTransitions called")
        anyCalled.isInverted = true

        _ = sut.subscribeTransitions(like: Transition(from: .s0, to: .s1)) {
            anyCalled.fulfill()
        }
        _ = sut.subscribeTransitions(to: .s1) {
            anyCalled.fulfill()
        }
        _ = sut.subscribeTransitions(from: .s0) {
            anyCalled.fulfill()
        }
        _ = sut.subscribeTransitions(from: .s0, to: .s1) {
            anyCalled.fulfill()
        }

        try sut.transition(to: .s1)
        self.wait(for: [anyCalled], timeout: 1)
    }

    private func prepare(initial state: Test = .s0, allowing transitions: Transition<Test>...) {
        sut = StateMachine<Test>(initial: state) { flow in
            for t in transitions {
                flow.allow(transition: t)
            }
        }
    }
}
