// Playground - noun: a place where people can play

import Finite

enum Test: Int {
    case saving, fetching, deleting
    case ready, fail
}

var machine = StateMachine<Test>(initial: .ready) { c in
    c.allow(from: [.saving, .fetching, .deleting], to: [.ready, .fail])
    c.allow(from: .ready, to: [.saving, .fetching, .deleting])
}

machine.onTransitions(from: .ready) {
    print("From ready: show activity indicator")
}
machine.onTransitions(to: .ready) {
    print("To ready: hide activity indicator")
}
machine.onTransitions(to: .saving) {
    print("To: save")
}
try machine.transition(to: .saving) {
    print("Triggered: save")
}

machine.state


enum State<T: Hashable>: Hashable {
    case ready
    case error
    case busy(T)

    var hashValue: Int {
        switch self {
        case .ready:
            return 0
        case .error:
            return 1
        case let .busy(b):
            return 2 + b.hashValue
        }
    }

    var isBusy: Bool {
        switch self {
        case .busy(_):
            return true
        default:
            return false
        }
    }
}

func == <T>(lhs: State<T>, rhs: State<T>) -> Bool {
    switch (lhs, rhs) {
    case (.ready, .ready):
        return true
    case (.error, .error):
        return true
    case let (.busy(lhb), .busy(rhb)):
        return lhb == rhb
    default:
        return false
    }
}

enum Process {
    case saving, fetching, deleting
}

var scnd = StateMachine<State<Process>>(initial: .ready) { flow in
    // allow transitions from busy
    flow.allow(to: [.ready, .error]) { transition in
        return transition.from?.isBusy ?? false
    }
    // allow transitions from ready to busy
    flow.allow(from: .ready) { t in
        return t.to?.isBusy ?? false
    }
    flow.allow(transition: Transition(from: nil, to: .busy(.deleting)))
}
do {
    try scnd.transition(to: State<Process>.busy(.deleting))
} catch {
    print(error)
}
