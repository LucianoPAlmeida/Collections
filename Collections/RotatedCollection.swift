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
    
    public struct Index {
        @usableFromInline
        let base: Base.Index
        @usableFromInline
        let offset: Int
        
        @inlinable
        init(base: Base.Index, offset: Int) {
            self.base = base
            self.offset = offset
        }
    }
}

extension RotatedCollection.Index: Comparable {
    public static func < (lhs: RotatedCollection<Base>.Index, rhs: RotatedCollection<Base>.Index) -> Bool {
        print("base: \(lhs.base), offset: \(lhs.offset) lhs")
        print("base: \(rhs.base), offset: \(rhs.offset) rhs")
        if lhs.offset == 0 && rhs.offset == 0 {
            return lhs.base < rhs.base
        }
        return lhs.offset < rhs.offset
    }
}

extension RotatedCollection: Collection {
    public typealias Element = Base.Element
    
    public var startIndex: RotatedCollection.Index {
        return Index(base: _base.startIndex, offset: computeBaseOffset(for: _base.startIndex))
    }
    
    public var endIndex: RotatedCollection.Index {
        return Index(base: _base.endIndex, offset: computeBaseOffset(for: _base.endIndex))
    }
    
    /// Complexity: O(1) only when `Base` conforms to ramdom access collection.
    public subscript(i: Index) -> Element {
        print(i.base)
//        guard _offset != 0 && _offset != _base.count else { return _base[i.base] }
////        //
////        //        let offset = computeBaseOffset(for: i)
////        //        return _base[_base.index(_base.startIndex, offsetBy: offset)]
////        fatalError()
        return _base[i.base]
    }
    
    @usableFromInline
    func computeBaseOffset(for i: Base.Index) -> Int {
        
        let distance = _base.distance(from: _base.startIndex, to: i)
        guard _offset != 0 && _offset != _base.count else { return distance }
        return (distance + _computedOffset)%_base.count
    }
    
    public var count: Int { return _base.count }
    
    @inlinable
    public func index(after i: Index) -> Index {
        print("i \(i)")
        let after = _base.index(after: i.base)
        return Index(base: after, offset: self.computeBaseOffset(for: after))
    }
}

extension Collection {
    public __consuming func rotated(by offset: Int) -> RotatedCollection<Self> {
        return RotatedCollection(_base: self, _offset: offset)
    }
}

