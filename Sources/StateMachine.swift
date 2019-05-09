//
//  StateMachine.swift
//  StateMachine
//
//  Created by Valentin Knabel on 19.02.15.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

#if !swift(>=3.0)
    /// A shim for Swift 3.0's Error protocol
    public typealias Error = ErrorType
#endif

/// Indicates that a transition failed.
public enum TransitionError<T: Hashable>: Error {
    /// Represents a tried transition that is not allowed.
    case denied(from: T, to: T)
}

/// Represents a state machine.
public struct StateMachine<T: Hashable>: CustomStringConvertible {
    /// An empty operation to be performed.
    public typealias Operation = () throws -> Void
    public typealias TransitionFilter = StateFlow<T>.TransitionFilter

    /// Stores the current state.
    internal var currentState: T
    /// Stores the immutable state flow.
    internal let configuration: StateFlow<T>
    /// Stores all transition handlers associated to transitions.
    internal var transitionHandlers: [Transition<T>: [Ref<Operation>]] = [:]

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
        currentState = initial
        configuration = StateFlow<T>(config: config)
    }

    /**
     Instantiates a state machine by passing an instance of StateFlow.

     - parameter initial: The initial state.
     - parameter stateFlow: The state flow to be used as configuration.
     */
    public init(initial: T, stateFlow: StateFlow<T>) {
        currentState = initial
        configuration = stateFlow
    }

    /**
     Triggers a transition to a given state and invokes a callback on completion.

     - parameter to: The targeted state.
     - parameter completion: An optional callback. Will be only be called on success and after all defined transition handlers were invoked.
     - throws: Either TransitionError or rethrows underlying errors.
     - returns: Wether the transition could be performed or not.
     */
    public mutating func transition(to: T, completion: Operation? = nil) throws {
        let transition = self.transition(to)
        if configuration.allows(transition) {
            for t in transition.generalTransitions + [.nilTransition] {
                if let handlers = self.transitionHandlers[t] {
                    for h in handlers {
                        try h.resolve()?() // rethrows
                    }
                }
                transitionHandlers[t]?.removeAll(where: { $0.resolve() == nil })
            }
            currentState = to
            try completion?()
        } else {
            throw TransitionError.denied(from: currentState, to: to)
        }
    }

    /**
     Returns wether transitioning to a state is allowed.

     - parameter to: The targeted state.
     - returns: true if allowed else false.
     */
    public func allows(to: T) -> Bool {
        return configuration.allows(transition(to))
    }

    private mutating func observeTransitions(like transition: Transition<T>, perform opRef: Ref<Operation>) {
        if transitionHandlers[transition] == nil {
            transitionHandlers[transition] = []
        }
        transitionHandlers[transition]?.append(opRef)
    }

    /**
     Appends a transition handler for all more-equal general transitions.

     - parameter transition: The most specific transition.
     - parameter perform: The operation the be performed.
     */
    public mutating func onTransitions(like transition: Transition<T> = .nilTransition, perform op: @escaping Operation) {
        observeTransitions(like: transition, perform: .strong(op))
    }

    /**
     Appends a transition handler for all more-equal general transitions.

     - parameter transition: The most specific transition.
     - parameter perform: The operation the be performed.
     */
    public mutating func subscribeTransitions(like transition: Transition<T> = .nilTransition, perform op: @escaping Operation) -> ReferenceDisposable {
        let (subscription, ref) = Ref.weak(op)
        observeTransitions(like: transition, perform: ref)
        return subscription
    }

    /**
     Returns the graph for the state machine
     */
    public var description: String {
        let result = "digraph {\n" + "graph [rankdir=LR]\n" + configuration.description + "\n}\n"
        return result
    }
}

internal extension StateMachine {
    #if swift(>=3.0)

        /// - returns: A transition from the current state to a given target.
        fileprivate func transition(_ to: T) -> Transition<T> {
            return Transition<T>(from: currentState, to: to)
        }

    #else

        /// - returns: A transition from the current state to a given target.
        private func transition(to: T) -> Transition<T> {
            return Transition<T>(from: currentState, to: to)
        }

    #endif
}

public extension StateMachine {
    /**
     Appends a transition handler for all more-equal general transitions.

     - parameter from: The source state.
     - parameter to: The target state.
     - parameter perform: The operation the be performed.
     */
    mutating func onTransitions(from: T, to: T, perform op: @escaping Operation) {
        let transition = Transition<T>(from: from, to: to)
        onTransitions(like: transition, perform: op)
    }

    /**
     Appends a transition handler for all more-equal general transitions.

     - parameter from: The source state.
     - parameter to: The target state.
     - parameter perform: The operation the be performed.
     - returns: subcription which needs to be kept.
     */
    mutating func subscribeTransitions(from: T, to: T, perform op: @escaping Operation) -> ReferenceDisposable {
        let transition = Transition<T>(from: from, to: to)
        return subscribeTransitions(like: transition, perform: op)
    }

    /**
     Appends a transition handler for all more-equal general transitions.

     - parameter from: The source state.
     - parameter perform: The operation the be performed.
     */
    mutating func onTransitions(from: T, perform op: @escaping Operation) {
        let transition = Transition<T>(from: from, to: nil)
        onTransitions(like: transition, perform: op)
    }

    /**
     Appends a transition handler for all more-equal general transitions.

     - parameter from: The source state.
     - parameter perform: The operation the be performed.
     - returns: subcription which needs to be kept.
     */
    mutating func subscribeTransitions(from: T, perform op: @escaping Operation) -> ReferenceDisposable {
        let transition = Transition<T>(from: from, to: nil)
        return subscribeTransitions(like: transition, perform: op)
    }

    /**
     Appends a transition handler for all more-equal general transitions.

     - parameter to: The target state.
     - parameter perform: The operation the be performed.
     */
    mutating func onTransitions(to: T, perform op: @escaping Operation) {
        let transition = Transition<T>(from: nil, to: to)
        onTransitions(like: transition, perform: op)
    }

    /**
     Appends a transition handler for all more-equal general transitions.

     - parameter to: The target state.
     - parameter perform: The operation the be performed.
     - returns: subcription which needs to be kept.
     */
    mutating func subscribeTransitions(to: T, perform op: @escaping Operation) -> ReferenceDisposable {
        let transition = Transition<T>(from: nil, to: to)
        return subscribeTransitions(like: transition, perform: op)
    }
}

public extension StateMachine {
    /**
     Appends a transition handler for all more-equal general transitions.
     Deprecated, use `StateMachine.onTransitions(like:perform:)` instead.
     Operations for .nilTransition will now be performed for every transition.

     - parameter transition: The most specific transition.
     - parameter perform: The operation the be performed.
     */
    @available(*, renamed: "onTransitions(like:perform:)", deprecated, message: "Operations for .nilTransition will now be performed for every transition")
    mutating func onTransitions(transition: Transition<T>, perform op: @escaping Operation) {
        observeTransitions(like: transition, perform: .strong(op))
    }
}
