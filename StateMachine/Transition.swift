//
//  Transition.swift
//  StateMachine
//
//  Created by Valentin Knabel on 19.02.15.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

/**
The Transition class represents a transition from a given state to a targeted state.
There are three types of transitions:

1. Absolute Transitions have a source and a target state set.
2. Relative Transitions have only one state set.
3. Nil Transitions have none states set and will be ignored.
*/
public struct Transition<T: Hashable>: Hashable {
    
    /// Nil transitions will be ignored.
    public static var nilTransition: Transition<T> {
        return Transition<T>(from: nil, to: nil)
    }
    
    /// The source state.
    public var from: T?
    /// The targeted state.
    public var to: T?
    
    /**
    Constructs an absolute, relative or nil transition.
    
    :param: from The source state.
    :param: to The target state.
    */
    public init(from: T?, to: T?) {
        self.from = from
        self.to = to
    }
    
    /** 
    All more general transitions include itself except the nil transition.
    
    :returns: All general transitions.
        
        - Generals of an absolute transition is itself and relative transitions.
        - Generals of a relative transition is only itself.
        - Nil transitions have no generals.
    */
    public var generalTransitions: [Transition<T>] {
        return deleteDuplicates([self, Transition<T>(from: from, to: nil), Transition<T>(from: nil, to: to)].filter { (t) -> Bool in
            return t != Transition<T>(from: nil, to: nil)
        })
    }
    
    /// The hash value.
    public var hashValue: Int {
        return (from?.hashValue ?? 0) + (to?.hashValue ?? 0)
    }
}

public func ==<T>(lhs: Transition<T>, rhs: Transition<T>) -> Bool {
    return lhs.from == rhs.from && lhs.to == rhs.to
}