//
//  IndexSetterTests.swift
//  DietAppTests
//
//  Created by 川島真之 on 2023/07/21.
//

import XCTest
@testable import DietApp

class IndexSetterTests: XCTestCase {
  var indexSetter: IndexSetter!
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func setUp() {
    super.setUp()
    indexSetter = IndexSetter()
  }
  //日付が17日以前だった場合のテスト
  func testIndexSettingBefore17() {
    let dateString = "2023-07-16"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: dateString)!
    
    let result = indexSetter.indexSetting(date: date)
    XCTAssertEqual(result, 0)
  }
  //日付が17日以降だった場合のテスト
  func testIndexSettingAfter17() {
    let dateString = "2023-07-18"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: dateString)!
    
    let result = indexSetter.indexSetting(date: date)
    XCTAssertEqual(result, 1)
  }
  
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
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
