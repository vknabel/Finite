//
//  SetFix.swift
//  StateMachine
//
//  Created by Valentin Knabel on 19.02.15.
//  Copyright (c) 2015 Valentin Knabel. All rights reserved.
//

///for swift < 1.2
internal struct Set<T : Hashable>: SequenceType
{
    internal typealias Generator = Array<T>.Generator
    
    internal var _items : Dictionary<T, Bool> = [:]
    
    internal mutating func add(newItem : T) {
        _items[newItem] = true
    }
    
    internal mutating func remove(newItem : T) {
        _items[newItem] = nil
    }
    
    internal func contains(item: T) -> Bool {
        if _items.indexForKey(item) != nil { return true } else { return false }
    }
    
    internal var items : [T] { get { return [T](_items.keys) } }
    internal var count : Int { get { return _items.count } }
    
    internal func generate() -> Generator {
        return items.generate()
    }
}