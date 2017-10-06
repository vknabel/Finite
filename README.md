[![CocoaPods](https://img.shields.io/cocoapods/v/Finite.svg?maxAge=2592000?style=flat-square)]()
[![CocoaPods](https://img.shields.io/cocoapods/p/Finite.svg?maxAge=2592000?style=flat-square)]()
[![Install](https://img.shields.io/badge/install-SwiftPM%20%7C%20Carthage%20%7C%20Cocoapods-lightgrey.svg?style=flat-square)]()
[![License](https://img.shields.io/cocoapods/l/Finite.svg?maxAge=2592000?style=flat-square)]()

# Finite

Finite is a simple, pure Swift finite state machine. Only exlicitly allowed transitions between states are allowed, otherwise an error will be thrown.

| **Finite** | **Swift**            |
|------------|----------------------|
| `2.0.0`    | `2.2` and `3.0 Beta` |
| `3.x.x`    | `3.0` and `4.0`      |

## Installation

EasyInject is a Swift only project and supports [Swift Package Manager](https://github.com/apple/swift-package-manager), [Carthage](https://github.com/Carthage/Carthage) and [CocoaPods](https://github.com/CocoaPods/CocoaPods).

### Swift Package Manager

```swift
import PackageDescription

let package = Package(
    name: "YourPackage",
    dependencies: [
        .Package(url: "https://github.com/vknabel/EasyInject.git", majorVersion: 3)
    ]
)
```

### Carthage

```ruby
github "vknabel/EasyInject"
```

### CocoaPods

```ruby
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

pod 'EasyInject'
```

## Introduction

It operates on a given type, where each value represents an internal state of the machine. A `StateMachine` is defined by providing all allowed state transitions.

```swift
enum Test: Int {
    case saving, Fetching, Deleting
    case Ready, Fail
}

var machine = StateMachine<Test>(initial: .ready) { c in
    c.allow(from: [.saving, .fetching, .deleting], to: [.ready, .fail])
    c.allow(from: .ready, to: [.saving, .fetching, .deleting])
}
```

It is possible to provide callbacks, that will be called once certain transitions will happen.

```swift
machine.onTransitions(from: .ready) {
    println("From Ready: show activity indicator")
}
machine.onTransitions(to: .ready) {
    println("To Ready: hide activity indicator")
}
machine.onTransitions(to: .saving) {
    println("To: save")
}
```

Once the `StateMachine` has been set up, you may trigger all transitions you have declared above.

```swift
try machine.transition(to: .saving) {
    println("Triggered: save")
}

// this will throw an error
try machine.transition(to: .fetching)
```

## Author

Valentin Knabel, dev@vknabel.com

## License

Finite is available under the [MIT](./LICENSE) license.
