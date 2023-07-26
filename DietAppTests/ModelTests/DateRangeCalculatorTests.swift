//
//  DateRangeCalculatorTests.swift
//  DietAppTests
//
//  Created by 川島真之 on 2023/07/26.
//

import XCTest
@testable import DietApp

class DateRangeCalculatorTests: XCTestCase {
  var dateRangeCalculator: DateRangeCalculator!
  

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
  
  override  func setUp() {
    dateRangeCalculator = DateRangeCalculator()
  }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
  //indexが偶数の場合のテスト
  func testCalculateMonthHalfDayRangeWithEvenIndex() {
    let results = dateRangeCalculator.calculateMonthHalfDayRange(index: 0)
    // 期待される開始日を設定します。
    let expectedStartDay = 1
    // 期待される終了日を設定します。
    let expectedEndDay = 16
    
    XCTAssertEqual(results.startDay, expectedStartDay)
    XCTAssertEqual(results.endDay, expectedEndDay)
  }
  //indexが奇数の場合のテスト
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

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
