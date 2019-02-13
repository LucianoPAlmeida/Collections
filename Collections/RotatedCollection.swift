//
//  RotatedCollection.swift
//  Collections
//
//  Created by Luciano Almeida on 10/02/19.
//  Copyright © 2019 Luciano Almeida. All rights reserved.
//

@_fixed_layout
public struct RotatedCollection<Base: Collection> {
    @usableFromInline
    internal let _base: Base
    @usableFromInline
    internal let _offset: Int
    @usableFromInline
    internal let _computedOffset: Int
    
    /// Complexity: O(1) only when `Base` conforms to ramdom access collection.
    @inlinable
    public init(_base: Base, _offset: Int) {
        self._base = _base
        self._offset = _offset%_base.count
        self._computedOffset = self._offset > 0 ? _base.count - self._offset : -self._offset
    }
}

extension RotatedCollection: Collection {
    
    public typealias Index = Base.Index
    public typealias Element = Base.Element
    
    public var startIndex: Base.Index { return _base.startIndex }
    public var endIndex: Base.Index { return _base.endIndex }
    
    /// Complexity: O(1) only when `Base` conforms to ramdom access collection.
    public subscript(i: Index) -> Element {
        guard _offset != 0 && _offset != _base.count else { return _base[i] }
        
        let offset = computeBaseOffset(for: i)
        return _base[_base.index(_base.startIndex, offsetBy: offset)]
    }
    
    private func computeBaseOffset(for i: Index) -> Int {
        let distance = _base.distance(from: _base.startIndex, to: i)
        return (distance + _computedOffset)%_base.count
    }
    
    public var count: Int { return _base.count }
    
    @inlinable
    public func index(after i: Index) -> Index {
        return _base.index(after: i)
    }
}

extension Collection {
    public __consuming func rotated(by offset: Int) -> RotatedCollection<Self> {
        return RotatedCollection(_base: self, _offset: offset)
    }
}

