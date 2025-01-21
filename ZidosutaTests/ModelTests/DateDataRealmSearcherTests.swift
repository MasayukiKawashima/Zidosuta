//
//  DateDataRealmSearcherTests.swift
//  ZidosutaTests
//
//  Created by 川島真之 on 2023/07/22.
//

import XCTest
import RealmSwift
@testable import Zidosuta

class DateDataRealmSearcherTests: XCTestCase {
  
  
  // MARK: - Properties
  
  var inMeomoryRealm: Realm!
  var searcher: DateDataRealmSearcher!
  
  
  // MARK: - Methods
  
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
  
  
  // MARK: - TestCases
  
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
}
