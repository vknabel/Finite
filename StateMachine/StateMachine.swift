//
//  StateMachine.swift
//  StateMachine
//
//  Created by Valentin Knabel on 19.02.15.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

/// Represents a state machine.
public struct StateMachine<T: Hashable> {
    
    /// An empty operation to be performed.
    public typealias Operation = () -> Void
    public typealias TransitionFilter = StateFlow<T>.TransitionFilter
    
    /// Stores the current state.
    private var currentState: T
    /// Stores the immutable state flow.
    private let configuration: StateFlow<T>
    /// Stores all transition handlers associated to transitions.
    private var transitionHandlers: [Transition<T>:[Operation]] = [:]
    
    /// The current state of the machine.
    public var state: T {
        return currentState
    }
    
    /** 
    Instantiates a state machine by configuring the StateFlow instance.
    
    - parameter initial: The initial state.
    - parameter config: A configurator for an instance of StateFlow.
    */
    public init(initial: T, config: StateFlow<T>.Configurator) {
        self.currentState = initial
        self.configuration = StateFlow<T>(config: config)
    }
    
    /**
    Instantiates a state machine by passing an instance of StateFlow.
    
    - parameter initial: The initial state.
    - parameter stateFlow: The state flow to be used as configuration.
    */
    public init(initial: T, stateFlow: StateFlow<T>) {
        self.currentState = initial
        self.configuration = stateFlow
    }
    
    /**
    Triggers a transition to a given state and invokes a callback on completion.
    
    - parameter to: The targeted state.
    - parameter completion: An optional callback. Will be only be called on success and after all defined transition handlers were invoked.
    - returns: Wether the transition could be performed or not.
    */
    public mutating func triggerTransition(to: T, completion: Operation? = nil) -> Bool {
        let transition = self.transition(to: to)
        if configuration.allows(transition: transition) {
            for t in transition.generalTransitions {
                if let handlers = self.transitionHandlers[t] {
                    for h in handlers {
                        h()
                    }
                }
            }
            self.currentState = to
            completion?()
            return true
        }
        return false
    }
    
    /**
    Returns wether transitioning to a state is allowed.
    
    - parameter to: The targeted state.
    - returns: true if allowed else false.
    */
    public func allows(to: T) -> Bool {
        return configuration.allows(transition: self.transition(to: to))
    }
    
    /**
    Appends a transition handler for all more-equal general transitions.
    
    - parameter transition: The most specific transition.
    - parameter perform: The operation the be performed.
    */
    public mutating func onTransitions(transition: Transition<T>, perform op: Operation) {
        if transitionHandlers[transition] == nil {
            transitionHandlers[transition] = []
        }
        transitionHandlers[transition]?.append(op)
    }
    
}

private extension StateMachine {
    
    /// - returns: A transition from the current state to a given target.
    private func transition(to: T) -> Transition<T> {
        return Transition<T>(from: self.currentState, to: to)
    }
    
}

public extension StateMachine {
    
    /**
    Appends a transition handler for all more-equal general transitions.
    
    - parameter from: The source state.
    - parameter to: The target state.
    - parameter perform: The operation the be performed.
    */
    public mutating func onTransitions(from: T, to: T, perform op: Operation) {
        let transition = Transition<T>(from: from, to: to)
        if transitionHandlers[transition] == nil {
            transitionHandlers[transition] = []
        }
        transitionHandlers[transition]?.append(op)
    }
    
    /**
    Appends a transition handler for all more-equal general transitions.
    
    - parameter from: The source state.
    - parameter perform: The operation the be performed.
    */
    public mutating func onTransitions(from: T, perform op: Operation) {
        let transition = Transition<T>(from: from, to: nil)
        if transitionHandlers[transition] == nil {
            transitionHandlers[transition] = []
        }
        transitionHandlers[transition]?.append(op)
    }
    
    /**
    Appends a transition handler for all more-equal general transitions.
    
    - parameter to: The target state.
    - parameter perform: The operation the be performed.
    */
    public mutating func onTransitions(to: T, perform op: Operation) {
        let transition = Transition<T>(from: nil, to: to)
        if transitionHandlers[transition] == nil {
            transitionHandlers[transition] = []
        }
        transitionHandlers[transition]?.append(op)
    }
    
}