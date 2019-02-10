//
//  ChunkedCollection.swift
//  Collections
//
//  Created by Luciano Almeida on 27/08/18.
//  Copyright © 2019 Luciano Almeida. All rights reserved.
//

/// A collection that presents the elements of its base collection
/// in `SubSequence` chunks of any given size.
///
/// A ChunkedCollection is a lazy view on the base Collection, but it does not implicitly confer
/// laziness on algorithms applied to its result.  In other words, for ordinary collections `c`:
///
/// * `c.chunks(of: 3)` does not create new storage
/// * `c.chunks(of: 3).map(f)` maps eagerly and returns a new array
/// * `c.lazy.chunks(of: 3).map(f)` maps lazily and returns a `LazyMapCollection`
@_fixed_layout
public struct ChunkedCollection<Base: Collection> {
    @usableFromInline
    internal let _base: Base
    @usableFromInline
    internal let _size: Int
    
    ///  Creates a view instance that presents the elements of `base`
    ///  in `SubSequence` chunks of the given size.
    ///
    /// - Complexity: O(1)
    @inlinable
    internal init(_base: Base, _size: Int) {
        self._base = _base
        self._size = _size
    }
}

extension ChunkedCollection: Collection {
    public typealias Index = Base.Index
    public typealias Element = Base.SubSequence
    public var startIndex: Base.Index { return _base.startIndex }
    public var endIndex: Base.Index { return _base.endIndex }
    public subscript(i: Index) -> Element { return _base[i..<index(after: i)] }
    
    @inlinable
    public func index(after i: Index) -> Index {
        return _base.index(i, offsetBy: _size, limitedBy: _base.endIndex) ?? _base.endIndex
    }
}

extension ChunkedCollection: BidirectionalCollection, RandomAccessCollection where Base: RandomAccessCollection {
    @inlinable
    public func index(before i: Index) -> Index {
        if i == _base.endIndex {
            let remainder = _base.count%_size
            if remainder != 0 {
                return _base.index(i, offsetBy: -remainder)
            }
        }
        return _base.index(i, offsetBy: -_size)
    }
    
    @inlinable
    public func distance(from start: Base.Index, to end: Base.Index) -> Int {
        let distance = _base.distance(from: start, to: end)
        return distance%_size != 0 ? distance/_size + 1 : distance/_size
    }
    
    @inlinable
    public func index(_ i: Base.Index, offsetBy n: Int) -> Base.Index {
        guard n != 0 else { return i }
        return _base.index(i, offsetBy: n * _size)
    }
    
    @inlinable
    public var count: Int {
        return _base.count%_size != 0 ? _base.count/_size + 1 : _base.count/_size
    }
}

extension Collection {
    /// Returns a `ChunkedCollection<Self>` view presenting the elements
    ///    in chunks with count of the given size parameter.
    ///
    /// - Parameter size: The size of the chunks. If the size parameter
    ///   is evenly divided by the count of the base `Collection` all the
    ///   chunks will have the count equals to size.
    ///   Otherwise, the last chunk will contain the remaining elements.
    ///
    ///     let c = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    ///     print(c.chunks(of: 5).map { [Int]($0) })
    ///     // [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10]]
    ///
    ///     print(c.chunks(of: 3).map { [Int]($0) })
    ///     // [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10]]
    ///
    /// - Complexity: O(1)
    @inlinable
    public __consuming func chunks(of size: Int) -> ChunkedCollection<Self> {
        _precondition(size > 0, "Split size should be greater than 0.")
        return ChunkedCollection(_base: self, _size: size)
    }
}
