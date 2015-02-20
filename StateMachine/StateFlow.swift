//
//  StateFlow.swift
//  StateMachine
//
//  Created by Valentin Knabel on 19.02.15.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

public struct StateFlow<T: Hashable> {
    
    public typealias TransitionFilter = (Transition<T>) -> Bool
    public typealias Configurator = (inout StateFlow<T>) -> Void
    
    /// empty array means transition is allowed. Once there is a single filter, all previous unconditioned transitions are omitted.
    private var transitionFilters: [Transition<T>:TransitionFilter?] = [:]
    
    public init(config: Configurator) {
        config(&self)
    }
    
    public init() {
        
    }
    
    public mutating func allowTransitions(transition: Transition<T>, filter: TransitionFilter? = nil) {
        if transitionFilters[transition] == nil {
            transitionFilters[transition] = filter
        }
    }
    
    public func allowsTransition(transition: Transition<T>) -> Bool {
        for t in transition.generalTransitions {
            if let opf = transitionFilters[transition] {
                let succ = opf?(transition) ?? true
                if succ {
                    return true
                }
            }
        }
        return false
    }
    
}

public extension StateFlow {
    
    public mutating func allowTransitions(#from: T, to: T, filter: TransitionFilter? = nil) {
        self.allowTransitions(Transition<T>(from: from, to: to), filter: filter)
    }
    
    public mutating func allowTransitions(#from: [T], to: T, filter: TransitionFilter? = nil) {
        for f in from {
            self.allowTransitions(Transition<T>(from: f, to: to), filter: filter)
        }
    }
    
    public mutating func allowTransitions(#from: T, to: [T], filter: TransitionFilter? = nil) {
        for t in to {
            self.allowTransitions(Transition<T>(from: from, to: t), filter: filter)
        }
    }
    
    public mutating func allowTransitions(#from: [T], to: [T], filter: TransitionFilter? = nil) {
        for f in from {
            for t in to {
                self.allowTransitions(Transition<T>(from: f, to: t), filter: filter)
            }
        }
    }
    
}