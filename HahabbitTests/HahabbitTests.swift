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

  func testCountDoneDaysForEachMonth() {
    let data = [
      20210102, 20210205, 20210318, 20210428,
      20210511, 20210609, 20210730, 20210821,
      20210903, 20211015, 20211126, 20211231
    ]

    data.forEach { date in
      sut.countDoneDaysForEachMonth(doneDate: date)
    }

    let result = sut.counter

    XCTAssertEqual(result, [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1])
  }

  func testCountDoneDaysForEachMonthIfInputIsNegativeOrZero() {
    let data = [-1234599, -12321412412123, -1, 0]

    data.forEach { date in
      sut.countDoneDaysForEachMonth(doneDate: date)
    }

    let result = sut.counter

    XCTAssertEqual(result, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
  }

  func testCountDoneDaysForEachMonthIfInputIsALargeNumber() {
    let data = [122332134234, 43534534345, 232556345435 ]

    data.forEach { date in
      sut.countDoneDaysForEachMonth(doneDate: date)
    }

    let result = sut.counter

    XCTAssertEqual(result, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
  }
}
