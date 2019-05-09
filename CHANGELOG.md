# Changelog

## 4.0.0

The new Finite offers you two new features: temporarily subscribing transitions and observing any transitions at once.

Use the new `onTransitions(perform:)` or `subscribeTransitions(perform:)` methods to observe all transitions.
Temporarily `subscribeTransitions` of your State Machines and bind the callbacks to the lifetime of your View Controllers. Just don't forget to store the subscription to bind `self` as `weak` or `unowned`.

### Breaking Changes

- Requires Swift 5
- Previously passing `Transition.nilTransition` to `StateMachine.onTransitions(like:perform:)` did never trigger the `perform` handler and was therefore useless. Now it will always be triggered.

### Additions

- Deprecated  `StateMachine.onTransitions(transition:perform:)` in favor of `StateMachine.onTransitions(like:perform:)`.
- The `StateMachine.onTransitions(perform:)` overload for `StateMachine.onTransitions(perform:)`.
- Adds temporary observation of transitions `subscribeTransitions(like:perform:)`, `subscribeTransitions(perform:)`, `subscribeTransitions(from:perform:)`, `subscribeTransitions(to:perform:)`, `subscribeTransitions(from:to:perform:)`. All return a `ReferenceDisposable` which needs to be stored as a strong reference. On deinit, the handler will be freed.

### Upgrading to 4.0.0

First bump your dependency version of Finite to `4.0.0`.
When you compile your project, you won't experience compile errors. Instead you will receive compiler warnings whenever you used `StateMachine.onTransitions(transition:perform:)`. If there are no warnings, you already finished the upgrade.

In case you passed `.nilTransition`: this did never work. Your `perform` operation has never been called!
Starting from 4.0.0, `.nilTransition` operations will always be called.

In case you did not pass a `.nilTransition`, apply the fix-it and use `onTransitions(like:perform:)` instead.

## 3.1.1

### Fixes

- Avoid assertion failure by combining hash values instead of summing them up - @iLuke93 @snofla

## 3.1.0

### Additions

- Introduced graphviz compatible descriptions - @snofla

## 3.0.3

*Released: 2017-10-06*

### Other Changes

- Readme updates - @vknabel
- Proven Swift 4.0 support - @vknabel

## 3.0.2

*Released: 2016-09-26*

### Other Changes

- Fixes Testing error - @vknabel

## 3.0.1

*Released: 2016-09-26*

### Other Changes

- Added support for Travis builds - @vknabel
- Added test support for Linux - @vknabel
- Updated docs - @vknabel

## 3.0.0

*Released: 2016-09-08*

### Breaking Changes

- Dropped Swift 2.2 and 2.3 support - @vknabel

## 2.0.0
*Released: 2016-08-22*

### Breaking Changes

- Renamed Project from `StateMachine` to `Finite` - @vknabel
- Renamed `StateMachine.triggerTransition(to:)` to `StateMachine.transition(to:)` - @vknabel
- `StateMachine.transition(to:)` throws `TransitionError` and rethrows - @vknabel

### API Additions

- `Operation`s may now throw - @vknabel
- Added `TransitionError`  - @vknabel
- Added Swift 3.0 Support - @vknabel
- Added generated Docs - @vknabel

### Other Changes

- Added `CocoaPods` and `Swift Package Manager` support - @vknabel
- Started this `CHANGELOG`.

