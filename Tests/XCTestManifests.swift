import XCTest

extension StateFlowTests {
    static let __allTests = [
        ("testAllowingConvenienceFromRelativeTransitionHelper", testAllowingConvenienceFromRelativeTransitionHelper),
        ("testAllowingConvenienceToRelativeTransitionHelper", testAllowingConvenienceToRelativeTransitionHelper),
        ("testAllowingEverythingMultipleConvenienceFromToAbsoluteTransitionHelperForEveryState", testAllowingEverythingMultipleConvenienceFromToAbsoluteTransitionHelperForEveryState),
        ("testAllowingMultipleConvenienceFromAbsoluteTransitionHelper", testAllowingMultipleConvenienceFromAbsoluteTransitionHelper),
        ("testAllowingMultipleConvenienceFromRelativeTransitionHelper", testAllowingMultipleConvenienceFromRelativeTransitionHelper),
        ("testAllowingMultipleConvenienceFromToAbsoluteTransitionHelper", testAllowingMultipleConvenienceFromToAbsoluteTransitionHelper),
        ("testAllowingMultipleConvenienceToAbsoluteTransitionHelper", testAllowingMultipleConvenienceToAbsoluteTransitionHelper),
        ("testAllowingMultipleConvenienceToRelativeTransitionHelper", testAllowingMultipleConvenienceToRelativeTransitionHelper),
        ("testAllowsAbsoluteTransitionsWhenAddedPreviously", testAllowsAbsoluteTransitionsWhenAddedPreviously),
        ("testAllowsAbsoluteTransitionsWhenAddedPreviouslyUsingEmptyInitializer", testAllowsAbsoluteTransitionsWhenAddedPreviouslyUsingEmptyInitializer),
        ("testAllowsAbsoluteTransitionWhenFromRelativeIsAllowed", testAllowsAbsoluteTransitionWhenFromRelativeIsAllowed),
        ("testAllowsAbsoluteTransitionWhenToRelativeIsAllowed", testAllowsAbsoluteTransitionWhenToRelativeIsAllowed),
        ("testAllowsAlwaysSucceedingFilter", testAllowsAlwaysSucceedingFilter),
        ("testAllowsFromRelativeTransitionsWhenAddedPreviously", testAllowsFromRelativeTransitionsWhenAddedPreviously),
        ("testAllowsToRelativeTransitionsWhenAddedPreviously", testAllowsToRelativeTransitionsWhenAddedPreviously),
        ("testDeniesAlwaysDenyingFilter", testDeniesAlwaysDenyingFilter),
        ("testDescriptionWithContents", testDescriptionWithContents),
        ("testDescriptionWithoutContents", testDescriptionWithoutContents),
        ("testDoesNotAllowAbsoluteTransitionsWhenAddedNilPreviously", testDoesNotAllowAbsoluteTransitionsWhenAddedNilPreviously),
        ("testDoesNotAllowNilTransitionsWhenAddedPreviously", testDoesNotAllowNilTransitionsWhenAddedPreviously),
        ("testDoesNotAllowTransitionsToSameStateByDefault", testDoesNotAllowTransitionsToSameStateByDefault),
        ("testDoesNotAllowUnrelatedAbsoluteTransitions", testDoesNotAllowUnrelatedAbsoluteTransitions),
        ("testEmptyDeniesEverything", testEmptyDeniesEverything),
        ("testEmptyDeniesEverythingForConfig", testEmptyDeniesEverythingForConfig)
    ]
}

extension StateMachineTests {
    static let __allTests = [
        ("testAllowedTransitionsDoNotThrowAndAdjustTheState", testAllowedTransitionsDoNotThrowAndAdjustTheState),
        ("testCreatingStateMachineWillSetState", testCreatingStateMachineWillSetState),
        ("testNotAllowedTransitionsDoThrowAndKeepTheState", testNotAllowedTransitionsDoThrowAndKeepTheState)
    ]
}

extension TransitionTests {
    static let __allTests = [
        ("testAbsolute", testAbsolute),
        ("testDescription", testDescription),
        ("testEqualty", testEqualty),
        ("testGeneral", testGeneral),
        ("testHash", testHash),
        ("testNil", testNil),
        ("testRelative", testRelative)
    ]
}

#if !os(macOS)
    public func __allTests() -> [XCTestCaseEntry] {
        return [
            testCase(StateFlowTests.__allTests),
            testCase(StateMachineTests.__allTests),
            testCase(TransitionTests.__allTests)
        ]
    }
#endif
