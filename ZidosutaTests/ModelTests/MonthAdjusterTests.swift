//
//  MonthAdjusterTests.swift
//  ZidosutaTests
//
//  Created by 川島真之 on 2023/08/06.
//

import XCTest
@testable import Zidosuta

class MonthAdjusterTests: XCTestCase {

  // MARK: - Properties

  var monthAdjuter: MonthAdjuster!

  var date: Date!

  // MARK: - Methods

  override func setUp() {

    super.setUp()

    monthAdjuter = MonthAdjuster()
    // テスト用Dateを作成
    let dateString = "2023-07-16"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    date = dateFormatter.date(from: dateString)!
  }

  // MARK: - TestCases

  // 現在の月を翌月にするテスト
  func testAdjustMonthToNextMonth() {

    // 翌月にするためにはindexの値が2である必要がある
    let index = 2
    let result = monthAdjuter.adjustMonth(index: index, date: date)

    let calendar = Calendar.current
    let month = calendar.component(.month, from: result)
    XCTAssertEqual(month, 8)
  }

  // 現在の月を翌々月にするテスト
  func testAdjustMonthToTwoMonthsAhead() {

    let index = 4
    let result = monthAdjuter.adjustMonth(index: index, date: date)

    let calendar = Calendar.current
    let month = calendar.component(.month, from: result)
    XCTAssertEqual(month, 9)
  }

  // 現在の月を前月にするテスト
  func testAdjustMonthToPreviousMonth() {

    let index = -1
    let result = monthAdjuter.adjustMonth(index: index, date: date)

    let calendar = Calendar.current
    let month = calendar.component(.month, from: result)
    XCTAssertEqual(month, 6)
  }

  // 現在の月を前前月にするテスト
  func testAdjustMonthToTwoMonthsBefore() {

    let index = -3
    let result = monthAdjuter.adjustMonth(index: index, date: date)

    let calendar = Calendar.current
    let month = calendar.component(.month, from: result)
    XCTAssertEqual(month, 5)
  }

  // 現在の月を維持するテスト
  func testAdjustMonthWithoutChange() {

    let index = 0
    let result = monthAdjuter.adjustMonth(index: index, date: date)

    let calendar = Calendar.current
    let month = calendar.component(.month, from: result)
    XCTAssertEqual(month, 7)
  }
}
