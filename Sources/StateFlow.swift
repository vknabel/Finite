//
//  StateFlow.swift
//  StateMachine
//
//  Created by Valentin Knabel on 19.02.15.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

/// Represents a configuration of a state machine.
public struct StateFlow<T: Hashable> {
    
    /// Filters wether a transition is allowed to be performed.
    public typealias TransitionFilter = (Transition<T>) -> Bool
    /// Configures the instance for immutable usage.
    public typealias Configurator = (inout StateFlow<T>) -> Void
    
    /// Empty array means transition is allowed. Once there is a single filter, all previous unconditioned transitions are omitted.
    private var transitionFilters: [Transition<T>:TransitionFilter?] = [:]
    
    /**
    Creates a new instance that can be mutated to be stored immutable.
    
    - parameter config: A function that mutates the constructed instance.
    */
    public init(config: Configurator) {
        config(&self)
    }
    
    /// Creates a new instance to be used mutable.
    public init() { }
    
    /** 
    Allows all less-equal general transitions to be triggered.
    
    - parameter transition: The transition allowing less-equal transitions.
    - parameter filter: An optional filter for transitions.
    */
    public mutating func allow(transition transition: Transition<T>, filter: TransitionFilter? = nil) {
        if transitionFilters[transition] == nil {
            transitionFilters[transition] = filter
        }
    }

    #if swift(>=3.0)
    /** 
    Returns wether a specific transition is allowed or not.
    Invokes defined transition filters until one returned true or a transition is unconditioned.
    
    - parameter transition: The transition to be tested.
    - returns: Returns true if a more-equal transition is allowed.
    */
    public func allows(_ transition: Transition<T>) -> Bool {
        for _ in transition.generalTransitions {
            if let opf = transitionFilters[transition] {
                let succ = opf?(transition) ?? true
                if succ {
                    return true
                }
            }
        }
        return false
    }
    #else
    /**
     Returns wether a specific transition is allowed or not.
     Invokes defined transition filters until one returned true or a transition is unconditioned.

     - parameter transition: The transition to be tested.
     - returns: Returns true if a more-equal transition is allowed.
     */
    public func allows(transition: Transition<T>) -> Bool {
        for _ in transition.generalTransitions {
            if let opf = transitionFilters[transition] {
                let succ = opf?(transition) ?? true
                if succ {
                    return true
                }
            }
        }
        return false
    }
    #endif
}

public extension StateFlow {
    
    /**
    Convinience method that allows all less-equal general absolute transitions to be triggered.
    
    - parameter from: The source state.
    - parameter filter: An optional filter for transitions.
    */
    public mutating func allow(from from: T, filter: TransitionFilter? = nil) {
        self.allow(transition: Transition<T>(from: from, to: nil), filter: filter)
    }
    
    /**
    Convinience method that allows all less-equal general absolute transitions to be triggered.
    
    - parameter to: The target state.
    - parameter filter: An optional filter for transitions.
    */
    public mutating func allow(to to: T, filter: TransitionFilter? = nil) {
        self.allow(transition: Transition<T>(from: nil, to: to), filter: filter)
    }
    
    /**
    Convinience method that allows all less-equal general absolute transitions to be triggered.
    
    - parameter from: The source state.
    - parameter to: The target state.
    - parameter filter: An optional filter for transitions.
    */
    public mutating func allow(from from: T, to: T, filter: TransitionFilter? = nil) {
        self.allow(transition: Transition<T>(from: from, to: to), filter: filter)
    }
    
    /**
    Convinience method that allows all less-equal general absolute transitions to be triggered.
    
    - parameter from: All source states.
    - parameter filter: An optional filter for transitions.
    */
    public mutating func allow(from from: [T], filter: TransitionFilter? = nil) {
        for f in from {
            self.allow(transition: Transition<T>(from: f, to: nil), filter: filter)
        }
    }
    
    /**
    Convinience method that allows all less-equal general absolute transitions to be triggered.
    
    - parameter from: All source states.
    - parameter to: The target state.
    - parameter filter: An optional filter for transitions.
    */
    public mutating func allow(from: [T], to: T, filter: TransitionFilter? = nil) {
        for f in from {
            self.allow(transition: Transition<T>(from: f, to: to), filter: filter)
        }
    }
    
    /**
    Convinience method that allows all less-equal general absolute transitions to be triggered.
    
    - parameter to: All target states.
    - parameter filter: An optional filter for transitions.
    */
    public mutating func allow(to: [T], filter: TransitionFilter? = nil) {
        for t in to {
            self.allow(transition: Transition<T>(from: nil, to: t), filter: filter)
        }
    }
    
    /**
    Convinience method that allows all less-equal general absolute transitions to be triggered.
    
    - parameter from: The source state.
    - parameter to: All target states.
    - parameter filter: An optional filter for transitions.
    */
    public mutating func allow(from: T, to: [T], filter: TransitionFilter? = nil) {
        for t in to {
            self.allow(transition: Transition<T>(from: from, to: t), filter: filter)
        }
    }
    
    /**
    Convinience method that allows all less-equal general absolute transitions to be triggered.
    
    - parameter from: All source states.
    - parameter to: All target states.
    - parameter filter: An optional filter for transitions.
    */
    public mutating func allow(from: [T], to: [T], filter: TransitionFilter? = nil) {
        for f in from {
            for t in to {
                self.allow(transition: Transition<T>(from: f, to: t), filter: filter)
            }
        }
    }
    
}

