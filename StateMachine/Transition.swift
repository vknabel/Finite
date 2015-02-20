//
//  Transition.swift
//  StateMachine
//
//  Created by Valentin Knabel on 19.02.15.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

public struct Transition<T: Hashable>: Hashable {
    
    public static var nilTransition: Transition<T> {
        return Transition<T>(from: nil, to: nil)
    }
    
    public var from: T?
    public var to: T?
    
    public var hashValue: Int {
        return (from?.hashValue ?? 0) + (to?.hashValue ?? 0)
    }
    
    /// Returns all derived transitions unequal nilTransition
    public var generalTransitions: [Transition<T>] {
        return [self, Transition<T>(from: from, to: nil), Transition<T>(from: nil, to: to)].filter { (t) -> Bool in
            return t != Transition<T>(from: nil, to: nil)
        }
    }
}

public func ==<T>(lhs: Transition<T>, rhs: Transition<T>) -> Bool {
    return lhs.from == rhs.from && lhs.to == rhs.to
}