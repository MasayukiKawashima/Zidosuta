//
//  IndexSetterTests.swift
//  ZidosutaTests
//
//  Created by 川島真之 on 2023/07/21.
//

import XCTest
@testable import Zidosuta

class IndexSetterTests: XCTestCase {

  // MARK: - Properties

  var indexSetter: IndexSetter!

  // MARK: - Methods

  override func setUp() {

    super.setUp()
    indexSetter = IndexSetter()
  }

  // MARK: -  TestCases

  // indexSettingのテスト
  // 日付が17日以前だった場合のテスト
  func testIndexSettingBefore17() {

    let dateString = "2023-07-16"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: dateString)!

    let result = indexSetter.indexSetting(date: date)
    XCTAssertEqual(result, 0)
  }

  // 日付が17日以降だった場合のテスト
  func testIndexSettingAfter17() {

    let dateString = "2023-07-18"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: dateString)!

    let result = indexSetter.indexSetting(date: date)
    XCTAssertEqual(result, 1)
  }
}
