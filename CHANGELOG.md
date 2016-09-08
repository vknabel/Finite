# 3.0.0
*Released: 2016-09-08*

**Breaking Changes:**
- Dropped Swift 2.2 and 2.3 support - @vknabel

# 2.0.0
*Released: 2016-08-22*

**Breaking Changes:**

- Renamed Project from `StateMachine` to `Finite` - @vknabel
- Renamed `StateMachine.triggerTransition(to:)` to `StateMachine.transition(to:)` - @vknabel
- `StateMachine.transition(to:)` throws `TransitionError` and rethrows - @vknabel

**API Additions:**

- `Operation`s may now throw - @vknabel
- Added `TransitionError`  - @vknabel
- Added Swift 3.0 Support - @vknabel
- Added generated Docs - @vknabel

**Other Changes:**

- Added `CocoaPods` and `Swift Package Manager` support - @vknabel
- Started this `CHANGELOG`.

