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
        case S0, S1
    }
    
    let a = ""
    let nilt = Transition<Test>.nilTransition
    let relft = Transition<Test>(from: Test.S0, to: nil)
    let reltt = Transition<Test>(from: nil, to: Test.S1)
    let abst = Transition<Test>(from: Test.S0, to: Test.S1)
    let abstr = Transition<Test>(from: Test.S1, to: Test.S0)
    var ts: [Transition<Test>] {
        return [nilt, relft, reltt, abst, abstr]
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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

}

