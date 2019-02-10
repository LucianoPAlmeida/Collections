//
//  RotatedCollectionTests.swift
//  CollectionsTests
//
//  Created by Luciano Almeida on 10/02/19.
//  Copyright © 2019 Luciano Almeida. All rights reserved.
//

import XCTest
public struct RotatedCollectionTest {
    public let expected: [Int]
    public let collection: [Int]
    public let offset: Int
    public init (
        expected: [Int], collection: [Int], offset: Int,
        file: String = #file, line: UInt = #line
        ) {
        self.expected = expected
        self.collection = collection
        self.offset = offset
    }
}

class RotatedCollectionTests: XCTestCase {

    let array = [1, 2, 3, 4]
    
    var rotatedCollectionTests: [RotatedCollectionTest] = []
    
    override func setUp() {
        rotatedCollectionTests = [
            RotatedCollectionTest(expected: [1, 2, 3, 4], collection: array, offset: 0),
            RotatedCollectionTest(expected: [4, 1, 2, 3], collection: array, offset: 5),
            RotatedCollectionTest(expected: [3, 4, 1, 2], collection: array, offset: 2),
            RotatedCollectionTest(expected: [1, 2, 3, 4], collection: array, offset: 4),
            RotatedCollectionTest(expected: [4, 1, 2, 3], collection: array, offset: 1),
            RotatedCollectionTest(expected: [2, 3, 4, 1], collection: array, offset: 3),
            RotatedCollectionTest(expected: [2, 3, 4, 1], collection: array, offset: -1),
            RotatedCollectionTest(expected: [4, 1, 2, 3], collection: array, offset: -3),
            RotatedCollectionTest(expected: [2, 3, 4, 1], collection: array, offset: -5)
        ]
    }

    func testRotatedCollection() {
        for test in rotatedCollectionTests {
            let rotated = test.collection.rotated(by: test.offset).map { $0 }
            XCTAssertEqual(test.expected, rotated)
        }
    }

}
