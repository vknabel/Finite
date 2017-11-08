//
//  TransitionTests.swift
//  StateMachine
//
//  Created by Valentin Knabel on 20.02.15.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

import XCTest
import Finite

class TransitionTests: XCTestCase {

    enum Test {
        case s0, s1
    }

    static var allTests = [
        ("testAbsolute", testAbsolute),
        ("testRelative", testRelative),
        ("testNil", testNil),
        ("testEqualty", testEqualty),
        ("testHash", testHash),
        ("testGeneral", testGeneral)
    ]

    var nilt: Transition<Test>!
    var relft: Transition<Test>!
    var reltt: Transition<Test>!
    var abst: Transition<Test>!
    var abstr: Transition<Test>!
    var ts: [Transition<Test>]! {
        return [nilt, relft, reltt, abst, abstr]
    }

    override func setUp() {
        nilt = Transition<Test>.nilTransition
        relft = Transition<Test>(from: Test.s0, to: nil)
        reltt = Transition<Test>(from: nil, to: Test.s1)
        abst = Transition<Test>(from: Test.s0, to: Test.s1)
        abstr = Transition<Test>(from: Test.s1, to: Test.s0)
    }

    func testAbsolute() {
        if abst.from == nil || abst.to == nil {
            XCTFail("Absolute Transition")
        }
    }

    func testRelative() {
        if relft.from == nil || relft.to != nil {
            XCTFail("Source Transition")
        }

        if reltt.from != nil || reltt.to == nil {
            XCTFail("Target Transition")
        }

    }

    func testNil() {
        let nilt = Transition<Test>(from: nil, to: nil)
        if nilt.from != nil || nilt.from != nil {
            XCTFail("Nil Transition")
        }
    }

    func testEqualty() {
        for li in 0..<ts.count {
            for ri in 0..<ts.count {
                XCTAssertEqual(ts[li] == ts[ri], li == ri, "Diagonal equal, else unequal")
            }
        }
    }

    func testHash() {
        // cannot test for unequalty => there may always be collisions
        for i in 0..<ts.count {
            XCTAssertEqual(ts[i].hashValue, ts[i].hashValue, "Diagonal hash equal")
        }
    }

    func testGeneral() {
        XCTAssertEqual(nilt.generalTransitions, [], "Nil transition generals")
        XCTAssertEqual(relft.generalTransitions, [relft], "Relative source transition generals")
        XCTAssertEqual(reltt.generalTransitions, [reltt], "Relative target transition generals")
        XCTAssertEqual(abst.generalTransitions, [abst, relft, reltt], "Absolute transition generals")
    }

    func testDescription() {
        XCTAssertEqual(nilt.description, "any -> any")
        XCTAssertEqual(relft.description, "s0 -> any")
        XCTAssertEqual(reltt.description, "any -> s1")
        XCTAssertEqual(abst.description, "s0 -> s1")
        XCTAssertEqual(abstr.description, "s1 -> s0")
    }
}

