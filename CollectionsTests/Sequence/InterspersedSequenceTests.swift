//
//  InterspersedSequenceTests.swift
//  CollectionsTests
//
//  Created by Luciano Almeida on 10/02/19.
//  Copyright © 2019 Luciano Almeida. All rights reserved.
//

import XCTest

class InterspersedSequenceTests: XCTestCase {

    func testInterspersedSequence() {
        let r = [1, 2, 3].interspersed(with: 4).map { $0 }
        XCTAssertEqual(r, [1, 4, 2, 4, 3])
    }

}
