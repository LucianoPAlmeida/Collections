//
//  InterspersedSequence.swift
//  Collections
//
//  Created by Luciano Almeida on 19/01/19.
//  Copyright © 2019 Luciano Almeida. All rights reserved.
//

/// A lazy view for sequence that creates a new sequece where for each iteration of the base sequence the value is inserted.
@frozen
public struct InterspersedSequence<Base: Sequence> {
    @usableFromInline
    var _base: Base
    @usableFromInline
    var _value: Element
    
    @inlinable
    public init(_base: Base, _value: Element) {
        self._base = _base
        self._value = _value
    }
    
    public struct Iterator {
        var _base: Base.Iterator
        var _value: InterspersedSequence.Element
        private var _intersperse: Bool = false
        private var _nextValue: Element?
        
        public init(_base: Base.Iterator, _value: InterspersedSequence.Element) {
            self._base = _base
            self._value = _value
            self._nextValue = self._base.next()
        }
    }
}

extension InterspersedSequence.Iterator: IteratorProtocol {
   public typealias Element = InterspersedSequence<Base>.Element
   public mutating func next() -> Element? {
        defer { _intersperse.toggle() }
        if _intersperse && _nextValue != nil {
            return _value
        }
        defer { _nextValue = _base.next() }
        return _nextValue
    }
}

extension InterspersedSequence: Sequence {
    public typealias Element = Base.Element
    
    public func makeIterator() -> InterspersedSequence<Base>.Iterator {
        return InterspersedSequence.Iterator(_base: _base.makeIterator(), _value: _value)
    }
}

extension Sequence {
    @inlinable
    public func interspersed(with value: Element) -> InterspersedSequence<Self> {
        return InterspersedSequence(_base: self, _value: value)
    }
}
