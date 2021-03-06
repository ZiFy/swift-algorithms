//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Algorithms open source project
//
// Copyright (c) 2020 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import XCTest
import Algorithms

final class StridingTests: XCTestCase {
  
  func testStride() {
    let a = 0...10
    XCTAssertEqualSequences(a.striding(by: 1), (0...10))
    XCTAssertEqualSequences(a.striding(by: 2), [0, 2, 4, 6, 8, 10])
    XCTAssertEqualSequences(a.striding(by: 3), [0, 3, 6, 9])
    XCTAssertEqualSequences(a.striding(by: 4), [0, 4, 8])
    XCTAssertEqualSequences(a.striding(by: 5), [0, 5, 10])
    XCTAssertEqualSequences(a.striding(by: 10), [0, 10])
    XCTAssertEqualSequences(a.striding(by: 11), [0])
    
    let s = (0...).prefix(11)
    XCTAssertEqualSequences(s.striding(by: 1), (0...10))
    XCTAssertEqualSequences(s.striding(by: 2), [0, 2, 4, 6, 8, 10])
    XCTAssertEqualSequences(s.striding(by: 3), [0, 3, 6, 9])
    XCTAssertEqualSequences(s.striding(by: 4), [0, 4, 8])
    XCTAssertEqualSequences(s.striding(by: 5), [0, 5, 10])
    XCTAssertEqualSequences(s.striding(by: 10), [0, 10])
    XCTAssertEqualSequences(s.striding(by: 11), [0])
    
    let empty = (0...).prefix(0)
    XCTAssertEqualSequences(empty.striding(by: 2), [])
  }
  
  func testStrideString() {
    let s = "swift"
    XCTAssertEqualSequences(s.striding(by: 2), ["s", "i", "t"])
  }
  
  func testStrideReversed() {
    let a = [0, 1, 2, 3, 4, 5]
    XCTAssertEqualSequences(a.striding(by: 3).reversed(), [3, 0])
    XCTAssertEqualSequences(a.reversed().striding(by: 2), [5, 3, 1])
  }
  
  func testStrideIndexes() {
    let a = [0, 1, 2, 3, 4, 5].striding(by: 2)
    var i = a.startIndex
    XCTAssertEqual(a[i], 0)
    a.formIndex(after: &i)
    XCTAssertEqual(a[i], 2)
    a.formIndex(after: &i)
    XCTAssertEqual(a[i], 4)
    a.formIndex(before: &i)
    XCTAssertEqual(a[i], 2)
    a.formIndex(before: &i)
    XCTAssertEqual(a[i], 0)
//    a.formIndex(before: &i) // Precondition failed: Incrementing past start index
//    a.index(after: a.endIndex) // Precondition failed: Advancing past end index
  }
  
  func testStrideCompositionEquivalence() {
    let a = (0...10)
    XCTAssertEqualSequences(a.striding(by: 6), a.striding(by: 2).striding(by: 3))
    XCTAssertTrue(a.striding(by: 6) == a.striding(by: 2).striding(by: 3))
    XCTAssert(type(of: a.striding(by: 2).striding(by: 3)) == Stride<ClosedRange<Int>>.self)
  }
  
  func testEquality() {
    let a = [1, 2, 3, 4, 5].striding(by: 2)
    let b = [1, 0, 3, 0, 5].striding(by: 2)
    XCTAssertEqual(a, b)
  }
  
  func testStrideLast() {
    XCTAssertEqual((1...10).striding(by: 2).last, 9) // 1, 3, 5, 7, 9
    XCTAssertEqual((1...10).striding(by: 3).last, 10) // 1, 4, 7, 10
    XCTAssertEqual((1...10).striding(by: 4).last, 9) // 1, 5, 9
    XCTAssertEqual((1...10).striding(by: 5).last, 6) // 1, 6
    XCTAssertEqual((1...100).striding(by: 50).last, 51) // 1, 51
    XCTAssertEqual((1...5).striding(by: 2).last, 5) // 1, 3, 5
    XCTAssertEqual([Int]().striding(by: 2).last, nil) // empty
  }
  
  func testCount() {
    let empty = [Int]().striding(by: 2)
    XCTAssertEqual(empty.count, 0)
    let a = (0...10)
    XCTAssertEqual(a.striding(by: 1).count, (0...10).count)
    XCTAssertEqual(a.striding(by: 2).count, [0, 2, 4, 6, 8, 10].count)
    XCTAssertEqual(a.striding(by: 3).count, [0, 3, 6, 9].count)
    XCTAssertEqual(a.striding(by: 4).count, [0, 4, 8].count)
    XCTAssertEqual(a.striding(by: 5).count, [0, 5, 10].count)
    XCTAssertEqual(a.striding(by: 10).count, [0, 10].count)
    XCTAssertEqual(a.striding(by: 11).count, [0].count)
  }
  
  func testIndexTraversals() {
    let empty = [Int]()
    validateIndexTraversals(
      empty.striding(by: 1),
      empty.striding(by: 2)
    )
    let zero_to_one_hundered_range = 0...100
    validateIndexTraversals(
      zero_to_one_hundered_range.striding(by: 10),
      zero_to_one_hundered_range.striding(by: 11),
      zero_to_one_hundered_range.striding(by: 101)
    )
    let zero_to_one_hundered_array = Array(zero_to_one_hundered_range)
    validateIndexTraversals(
      zero_to_one_hundered_array.striding(by: 10),
      zero_to_one_hundered_array.striding(by: 11),
      zero_to_one_hundered_array.striding(by: 101)
    )
    let string = "swift rocks".map(String.init)
    validateIndexTraversals(
      string.striding(by: 1),
      string.striding(by: 2),
      string.striding(by: 10)
    )
  }

  
  func testOffsetBy() {
    let a = (0...100).striding(by: 22)
    let b = [0, 22, 44, 66, 88]
    for i in 0..<a.count {
      XCTAssertEqual(a[a.index(a.startIndex, offsetBy: i)], b[i])
    }
  }
  
  func testOffsetByEndIndex() {
    let a = 1...5
    let b = a.striding(by: 3) // [1, 4]
    let i = b.index(b.startIndex, offsetBy: 2)
    XCTAssertEqual(i, b.endIndex)
  }
}
