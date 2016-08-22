// Playground - noun: a place where people can play

import Finite

enum Test: Int {
    case Saving, Fetching, Deleting
    case Ready, Fail
}

var machine = StateMachine<Test>(initial: .Ready) { c in
    c.allow(from: [.Saving, .Fetching, .Deleting], to: [.Ready, .Fail])
    c.allow(from: .Ready, to: [.Saving, .Fetching, .Deleting])
}

machine.onTransitions(from: .Ready) {
    print("From Ready: show activity indicator")
}
machine.onTransitions(to: .Ready) {
    print("To Ready: hide activity indicator")
}
machine.onTransitions(to: .Saving) {
    print("To: save")
}
try machine.transition(to: .Saving) {
    print("Triggered: save")
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
        case .Error:
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

var scnd = StateMachine<State<Process>>(initial: .Ready) { flow in
    //allow transitions from busy
    flow.allow(to: [.Ready, .Error]) { transition in
        return transition.from?.isBusy ?? false
    }
    //allow transitions from ready to busy
    flow.allow(from: .Ready) { t in
        return t.to?.isBusy ?? false
    }
}






