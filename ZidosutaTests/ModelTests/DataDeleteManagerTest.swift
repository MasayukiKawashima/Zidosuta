//
//  DataDeleteManagerTest.swift
//  ZidosutaTests
//
//  Created by 川島真之 on 2024/12/15.
//

import XCTest
import RealmSwift
@testable import Zidosuta


// MARK: - TestRealmObject

class TestRealmObject: Object {
  @Persisted var id = UUID().uuidString
}


// MARK: - DataDeleteManagerTests

final class DataDeleteManagerTests: XCTestCase {


  // MARK: - Properties

  var sut: DataDeleteManager!
  var fileManager: FileManager!
  var documentURL: URL!
  var dummyFiles: [String]!
  var fileURLs: [URL]!


  // MARK: - Methods

  override func setUp() async throws {

    try await super.setUp()

    sut = DataDeleteManager.shared
    fileManager = FileManager.default
    documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    dummyFiles = ["DummyFile1.txt", "DummyFile2.text", "DummyFile3.text"]
    fileURLs = dummyFiles.map { documentURL.appendingPathComponent($0) }

    try await setupTestData()
  }

  override func tearDown() async throws {

    sut = nil
    fileManager = nil
    documentURL = nil
    dummyFiles = nil
    fileURLs = nil

    try await super.tearDown()
  }

  private func setupTestData() async throws {

    // RealmオブジェクトをMainActor.runで作成
    await MainActor.run {
      let realm = try! Realm()
      try! realm.write {
        realm.add(TestRealmObject())
      }
    }

    // ダミーファイルを作成
    for (dummyFile, fileURL) in zip(dummyFiles, fileURLs) {
      try dummyFile.write(to: fileURL, atomically: true, encoding: .utf8)
    }
  }


  // MARK: - TestCases

  // deleteAllDataのテスト
  // 成功の場合のテスト
  func testDeleteAllData_Success() async {

    let result = await sut.deleteAllData()
    XCTAssertTrue(result)

    // 保存したダミーファイルが削除されているか確認
    for fileURL in fileURLs {
      let exists = fileManager.fileExists(atPath: fileURL.path)
      XCTAssertFalse(exists)
    }
  }

  // ドキュメントディレクトリがRealmファイル以外空の場合のテスト
  func testDeleteAllData_EmptyDirectorySuccess() async {

    // ドキュメントディレクトリを事前にクリア
    let contents = try? fileManager.contentsOfDirectory(
      at: documentURL,
      includingPropertiesForKeys: nil,
      options: []
    )
    try? contents?.forEach { url in
      guard !url.lastPathComponent.hasPrefix("default.realm") else {
        print("ℹ️ default.realmファイルの削除はスキップします: \(url.lastPathComponent)")
        return
      }
      try fileManager.removeItem(at: url)
    }

    let result = await sut.deleteAllData()
    XCTAssertTrue(result)
  }

  // default.realmファイルの削除をスキップできているかテスト
  func testDeleteAllData_SkipDeleteRealmData() async {

    let result = await sut.deleteAllData()
    XCTAssertTrue(result)

    do {
      let fileURLs = try FileManager.default.contentsOfDirectory(
        at: documentURL,
        includingPropertiesForKeys: nil,
        options: .skipsHiddenFiles
      )
      for file in fileURLs {
        let isRealmFile = file.lastPathComponent.hasPrefix("default.realm")
        XCTAssertTrue(isRealmFile)
      }
    } catch {
      print("ドキュメントディレクトリ内のファイル一覧取得に失敗しました: \(error)")
    }
  }

  // 通知リクエストが削除できているかのテスト
  func testDeleteAllData_RemoveNotificationRequests() async {

    let center = UNUserNotificationCenter.current()

    // テスト用通知リクエストを設定
    let content = UNMutableNotificationContent()
    content.title = "テスト通知"
    content.body = "これはテスト用の通知です"
    content.sound = .default

    let component = DateComponents(hour: 12, minute: 0)
    let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
    let request = UNNotificationRequest(identifier: "alarm_id", content: content, trigger: trigger)

    await withCheckedContinuation { continuation in
      center.add(request) { error in
        if let error {
          print(error.localizedDescription)
        }
        continuation.resume()
      }
    }

    let result = await sut.deleteAllData()
    XCTAssertTrue(result)

    let requests = await center.pendingNotificationRequests()
    XCTAssertTrue(requests.isEmpty)
  }

  // RealmObjectが存在しない場合のテスト
  func testDeleteAllData_EmptyRealmObjectSuccess() async {

    // 全てのRealmObjectをMainActor.runで事前削除
    await MainActor.run {
      let realm = try! Realm()
      try! realm.write {
        realm.deleteAll()
      }
    }

    let result = await sut.deleteAllData()
    XCTAssertTrue(result)
  }
}
