//
//  DateDataRealmSearcherTests.swift
//  DietAppTests
//
//  Created by 川島真之 on 2023/07/22.
//

import XCTest
import RealmSwift
@testable import DietApp


class DateDataRealmSearcherTests: XCTestCase {
  
  var inMeomoryRealm: Realm!
  var searcher: DateDataRealmSearcher!
  
  override  func setUp() {
    super.setUp()
    //realmの初期化をメモリ上で行う。
    //これにより、各テストが孤立して実行され、実際のアプリケーションのデータに影響を与えないことを保証します。
    inMeomoryRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "inMemoryRealm"))
    searcher = DateDataRealmSearcher(realm: inMeomoryRealm)
  }
  
  
  override  func tearDown() {
    // 使用後の Realm を無効化します。
    // 各テスト後のクリーンアップは、テストが互いに影響を与えないことを保証するために重要です。
    inMeomoryRealm.invalidate()
    
    searcher = nil
    inMeomoryRealm = nil
    
    super.tearDown()
  }
  //テストを実行するメソッド
  func testSearchForDateDataInRealm() {
  
    let dateData = DateData()
    let currentDate = Date()
    dateData.date = currentDate
    try! inMeomoryRealm.write {
      inMeomoryRealm.add(dateData)
    }
    
    let results = searcher.searchForDateDataInRealm(currentDate: currentDate)
    //テストの結果を検証する
    //まず、検索結果が一つであることを確認
    XCTAssertEqual(results.count, 1)
    //それが上で追加したレコードと同じものであるかを確認
    XCTAssertEqual(results.first!.date, dateData.date)
  }
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
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
