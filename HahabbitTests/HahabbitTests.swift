//
//  HahabbitTests.swift
//  HahabbitTests
//
//  Created by TSAI TSUNG-HAN on 2021/6/19.
//

import XCTest
@testable import Hahabbit

class HahabbitTests: XCTestCase {

  var sut: GraphViewModel!

  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = GraphViewModel()
  }

  override func tearDownWithError() throws {
    sut = nil
    try super.tearDownWithError()
  }

  func testFindMaxConsecutiveTrue() throws {
    let data = [true, false, false, true, true, true, false]
    let result = sut.findMaxConsecutiveTrue(array: data)
    XCTAssertEqual(result, 3)
  }

  func testFindMaxConsecutiveTrueIfArrayIsEmpty() throws {
    let data: [Bool] = []
    let result = sut.findMaxConsecutiveTrue(array: data)
    XCTAssertEqual(result, 0)
  }
}
