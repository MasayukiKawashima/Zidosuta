//
//  DateRangeCalculatorTests.swift
//  ZidosutaTests
//
//  Created by 川島真之 on 2023/07/26.
//

import XCTest
@testable import Zidosuta

class DateRangeCalculatorTests: XCTestCase {

  // MARK: - Properties

  var dateRangeCalculator: DateRangeCalculator!

  // MARK: - Methods

  override  func setUp() {

    dateRangeCalculator = DateRangeCalculator()
  }

  // MARK: - TestCases

  // calculateMonthHalfDayRangeのテスト
  // indexが偶数の場合のテスト
  func testCalculateMonthHalfDayRangeWithEvenIndex() {

    let results = dateRangeCalculator.calculateMonthHalfDayRange(index: 0)
    // 期待される開始日を設定します。
    let expectedStartDay = 1
    // 期待される終了日を設定します。
    let expectedEndDay = 16

    XCTAssertEqual(results.startDay, expectedStartDay)
    XCTAssertEqual(results.endDay, expectedEndDay)
  }

  // indexが奇数の場合のテスト
  func testCalculateMonthHalfDayRangeWithOddIndex() {

    let date = DateComponents(calendar: Calendar.current, year: 2023, month: 7, day: 1).date!
    let results = dateRangeCalculator.calculateMonthHalfDayRange(index: 1, date: date)
    // 期待される開始日を設定します。
    let expectedStartDay = 17
    // 期待される終了日を設定します。
    let expectedEndDay =  31

    XCTAssertEqual(results.startDay, expectedStartDay)
    XCTAssertEqual(results.endDay, expectedEndDay)
  }
}
