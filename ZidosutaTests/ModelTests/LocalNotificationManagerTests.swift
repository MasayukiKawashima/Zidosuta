//
//  LocalNotificationManagerTests.swift
//  ZidosutaTests
//
//  Created by 川島真之 on 2025/01/01.
//

import XCTest
@testable import Zidosuta

// 2025.12 備忘録
// 現在以下のテストは失敗する
// 現在のLocalNotificationManagerがテスト不能な仕様になっているため
// なので将来的にLocalNotificationManagerとテストの大幅なリファレンスが必要だと考えられる
// テスト不能の理由として、考えられる理由を以下に残しておく
// 1. テストではユーザーへ通知の許可（アラートでユーザーに通知権限の問い合わせを行うやつ）を求めることができないから。
//    そのため常に通知権限のステータスが.authorized（許可）にならず、許可された場合の処理が実行されない
// 2. LocalNotificationManagerの通知登録処理が非同期処理だが、この処理にcompletion（テストで登録の検証を行う処理など）を渡すことができるような仕様になっていないため

class LocalNotificationManagerTests: XCTestCase {

  // MARK: - Properties

  var notificationManager: LocalNotificationManager!
  var notificationCenter: UNUserNotificationCenter!

  // MARK: - Methods

  override func setUp() {

    super.setUp()

    notificationManager = LocalNotificationManager.shared
    notificationCenter = UNUserNotificationCenter.current()
  }

  override func tearDown() {

    notificationCenter.removeAllPendingNotificationRequests()

    super.tearDown()
  }

  // MARK: - TestCases

  // setScheduleNotificationのテスト
  func testSetScheduleNotification() {

    let expectation = XCTestExpectation(description: "Notification scheduled")

    notificationManager.setScheduleNotification()

    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.notificationCenter.getPendingNotificationRequests { requests in
        // テスト1: 通知リクエストが登録できているか
        XCTAssertTrue(requests.contains { $0.identifier == "dailyReminder" })

        // テスト2: 保留中のリクエスト数が1つであるか
        XCTAssertEqual(requests.count, 1)

        expectation.fulfill()
      }
    }
    wait(for: [expectation], timeout: 2.0)
  }
}
