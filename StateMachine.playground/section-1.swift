// Playground - noun: a place where people can play

import StateMachine

enum Test: Int {
    case Saving, Fetching, Deleting
    case Ready, Fail
}

var machine = StateMachine<Test>(initial: .Ready) { c in
    c.allowTransitions(from: [.Saving, .Fetching, .Deleting], to: [.Ready, .Fail])
    c.allowTransitions(from: .Ready, to: [.Saving, .Fetching, .Deleting])
}

machine.onTransitions(from: .Ready) {
    println("From Ready: show activity indicator")
}
machine.onTransitions(to: .Ready) {
    println("To Ready: hide activity indicator")
}
machine.onTransitions(to: .Saving) {
    println("To: save")
}
machine.triggerTransition(to: .Saving) {
    println("Triggered: save")
}

machine.state.rawValue


enum State<T: Hashable>: Hashable {
    case Ready
    case Error
    case Busy(T)
    
    var hashValue: Int {
        switch self {
        case .Ready:
            return 0
        case Error:
            return 1
        case let .Busy(b):
            return 2 + b.hashValue
        }
    }
    
    var isBusy: Bool {
        switch self {
        case .Busy(_):
            return true
        default:
            return false
        }
    }
}

func ==<T: Hashable>(lhs: State<T>, rhs: State<T>) -> Bool {
    switch (lhs, rhs) {
    case (.Ready, .Ready):
        return true
    case (.Error, .Error):
        return true
    case let (.Busy(lhb), .Busy(rhb)):
        return lhb == rhb
    default:
        return false
    }
}

enum Process {
    case Saving, Fetching, Deleting
}

var scnd = StateMachine<State<Process>>(initial: .Ready) { (inout c: StateFlow<State<Process>>) in
    //allow transitions from busy
    c.allowTransitions(to: [.Ready, .Error]) { transition in
        return transition.from?.isBusy ?? false
    }
    //allow transitions from ready to busy
    c.allowTransitions(from: .Ready) { t in
        return t.to?.isBusy ?? false
    }
}






