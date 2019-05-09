/// A subsription reference which needs to be referenced strongly.
public protocol ReferenceDisposable {
    /// Disposes the current subscription. Current and future operations will be canceled.
    func dispose()
}

internal class Ref<T> {
    private var value: () -> T?

    init(dereference: @escaping () -> T?) {
        value = dereference
    }

    func resolve() -> T? {
        return value()
    }

    func free() {
        value = { nil }
    }
}

extension Ref {
    static func weak(_ value: T) -> (ReferenceDisposable, Ref) {
        let lifetime = Box(value)
        let weak = Weak(value: lifetime)
        return (
            lifetime,
            .init(dereference: { weak.value?.value })
        )
    }

    static func strong(_ value: T) -> Ref {
        return .init(dereference: { value })
    }

    private struct Weak<T> {
        fileprivate weak var value: Box<T>?
    }

    private class Box<T>: ReferenceDisposable {
        var value: T?

        init(_ value: T?) {
            self.value = value
        }

        func dispose() {
            value = nil
        }
    }
}
