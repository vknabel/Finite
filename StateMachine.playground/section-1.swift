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