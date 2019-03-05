//
//  RotatedCollection.swift
//  Collections
//
//  Created by Luciano Almeida on 10/02/19.
//  Copyright © 2019 Luciano Almeida. All rights reserved.
//

@_fixed_layout
public struct RotatedCollection<Base: RandomAccessCollection> {
    @usableFromInline
    internal let _base: Base
    @usableFromInline
    internal let _offset: Int
    @usableFromInline
    internal let _computedOffset: Int
    
    /// Complexity: O(1).
    @inlinable
    public init(_base: Base, _offset: Int) {
        self._base = _base
        guard !_base.isEmpty && _offset != 0 else {
            self._offset = 0
            self._computedOffset = 0
            return
        }
        self._offset = _offset%_base.count
        self._computedOffset = self._offset > 0 ? _base.count - self._offset : -self._offset
    }
}

extension RotatedCollection {
    // RotatedCollection Index.
    public struct Index {
        @usableFromInline
        let base: Base.Index
        @usableFromInline
        let baseOffset: Int
        
        @inlinable
        init(base: Base.Index, baseOffset: Int) {
            self.base = base
            self.baseOffset = baseOffset
        }
    }
}

extension RotatedCollection.Index: Comparable {
    public static func < (lhs: RotatedCollection<Base>.Index, rhs: RotatedCollection<Base>.Index) -> Bool {
        return lhs.baseOffset < rhs.baseOffset
    }
}

extension RotatedCollection: Collection {
    public typealias Element = Base.Element
    
    public var startIndex: RotatedCollection.Index {
        return Index(base: _base.startIndex, baseOffset: computeBaseOffset(for: _base.startIndex))
    }
    
    public var endIndex: RotatedCollection.Index {
        return Index(base: _base.endIndex, baseOffset: computeBaseOffset(for: _base.endIndex))
    }
    
    /// Complexity: O(1).
    public subscript(i: Index) -> Element {
        return _base[_base.index(_base.startIndex, offsetBy: i.baseOffset)]
    }
    
    @usableFromInline
    func computeBaseOffset(for i: Base.Index) -> Int {
        let distance = _base.distance(from: _base.startIndex, to: i)
        let baseCount = _base.count
        guard _offset != 0 && _offset != baseCount else { return distance }

        return (distance + _computedOffset)%baseCount
    }
    
    public var count: Int { return _base.count }
    
    /// Complexity: O(1).
    @inlinable
    public func index(after i: Index) -> Index {
        let after = _base.index(after: i.base)
        return Index(base: after, baseOffset: self.computeBaseOffset(for: after))
    }
}

extension RandomAccessCollection {
    public __consuming func rotated(by offset: Int) -> RotatedCollection<Self> {
        return RotatedCollection(_base: self, _offset: offset)
    }
}

