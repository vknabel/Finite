# Changelog

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

