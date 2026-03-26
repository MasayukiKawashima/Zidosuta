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

  var inMemoryRealm: Realm!
  var searcher: DateDataRealmSearcher!


  // MARK: - Methods

  override  func setUp() {

    super.setUp()
    // realmの初期化をメモリ上で行う。
    // これにより、各テストが孤立して実行され、実際のアプリケーションのデータに影響を与えないことを保証します。
    inMemoryRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "inMemoryRealm"))
    searcher = DateDataRealmSearcher(realm: inMemoryRealm)
  }

  override  func tearDown() {

    inMemoryRealm.invalidate()

    searcher = nil
    inMemoryRealm = nil

    super.tearDown()
  }


  // MARK: - TestCases

  // searchForDateDataInRealmのテスト
  func testSearchForDateDataInRealm() {

    let dateData = DateData()
    let currentDate = Date()
    dateData.date = currentDate
    try! inMemoryRealm.write {
      inMemoryRealm.add(dateData)
    }

    let results = searcher.searchForDateDataInRealm(currentDate: currentDate)
    // テストの結果を検証する
    // まず、検索結果が一つであることを確認
    XCTAssertEqual(results.count, 1)
    // それが上で追加したレコードと同じものであるかを確認
    XCTAssertEqual(results.first!.date, dateData.date)
  }
}
