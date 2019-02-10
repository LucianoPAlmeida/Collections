//
//  ChunkedCollectionTests.swift
//  CollectionsTests
//
//  Created by Luciano Almeida on 10/02/19.
//  Copyright © 2019 Luciano Almeida. All rights reserved.
//

import XCTest
@testable import Collections

public struct ChuckedCollectionTest {
    public let expected: [[Int]]
    public let collection: [Int]
    public let size: Int
    public init (
        expected: [[Int]], collection: [Int], size: Int,
        file: String = #file, line: UInt = #line
        ) {
        self.expected = expected
        self.collection = collection
        self.size = size
    }
}

final class ChunkedCollectionsTests: XCTestCase {
    
    let chunckedCollectionTests = [
        ChuckedCollectionTest(
            expected: [],
            collection: [],
            size: 1
        ),
        ChuckedCollectionTest(
            expected: [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10]],
            collection: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
            size: 3
        ),
        ChuckedCollectionTest(
            expected: [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10]],
            collection: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
            size: 5
        ),
        ChuckedCollectionTest(
            expected: [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]],
            collection: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
            size: 11
        )
    ]
    
    func testChunkedCollection() {
        for test in chunckedCollectionTests {
            let collection = test.collection
            XCTAssertEqual(test.expected, collection.chunks(of: test.size).map(Array.init))
            XCTAssertEqual(test.expected.reversed(), collection.chunks(of: test.size).reversed().map(Array.init))
        }
    }
    
}
