//
//  StateMachine.swift
//  StateMachine
//
//  Created by Valentin Knabel on 19.02.15.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

public struct StateMachine<T: Hashable> {
    
    public typealias Operation = () -> Void
    public typealias TransitionFilter = (Transition<T>) -> Bool
    
    private var currentState: T
    private let configuration: StateFlow<T>
    private var transitionHandlers: [Transition<T>:[Operation]] = [:]
    
    public var state: T {
        return currentState
    }
    
    public init(initial: T, config: (inout StateFlow<T>) -> Void) {
        self.currentState = initial
        self.configuration = StateFlow<T>(config)
    }
    
    public mutating func triggerTransition(#to: T, completion: Operation? = nil) -> Bool {
        let transition = self.transition(to: to)
        if configuration.allowsTransition(transition) {
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
    
    public func allowsTransition(#to: T) -> Bool {
        return configuration.allowsTransition(self.transition(to: to))
    }
    
    public mutating func onTransitions(transition: Transition<T>, perform op: Operation) {
        if transitionHandlers[transition] == nil {
            transitionHandlers[transition] = []
        }
        transitionHandlers[transition]?.append(op)
    }
    
}

private extension StateMachine {
    
    private func transition(#to: T) -> Transition<T> {
        return Transition<T>(from: self.currentState, to: to)
    }
    
}

public extension StateMachine {
    
    public mutating func onTransitions(#from: T, to: T, perform op: Operation) {
        let transition = Transition<T>(from: from, to: to)
        if transitionHandlers[transition] == nil {
            transitionHandlers[transition] = []
        }
        transitionHandlers[transition]?.append(op)
    }
    
    public mutating func onTransitions(#from: T, perform op: Operation) {
        let transition = Transition<T>(from: from, to: nil)
        if transitionHandlers[transition] == nil {
            transitionHandlers[transition] = []
        }
        transitionHandlers[transition]?.append(op)
    }
    
    public mutating func onTransitions(#to: T, perform op: Operation) {
        let transition = Transition<T>(from: nil, to: to)
        if transitionHandlers[transition] == nil {
            transitionHandlers[transition] = []
        }
        transitionHandlers[transition]?.append(op)
    }
    
}