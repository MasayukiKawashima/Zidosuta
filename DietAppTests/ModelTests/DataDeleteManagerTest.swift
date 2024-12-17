//
//  DataDeleteManagerTest.swift
//  DietAppTests
//
//  Created by 川島真之 on 2024/12/15.
//

import XCTest
import RealmSwift
@testable import DietApp

class TestRealmObject: Object {
  @Persisted var id = UUID().uuidString
}

final class DataDeleteManagerTests: XCTestCase {
  
  var sut: DataDeleteManager!
  var realm: Realm!
  var fileManager: FileManager!
  var documentURL: URL!
  var dummyFiles: [String]!
  var fileURLs:[URL]!
  
  override func setUp() {
    super.setUp()
    sut = DataDeleteManager.shared
    realm = try! Realm()
    fileManager = FileManager.default
    documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    dummyFiles = ["DummyFile1.txt", "DummyFile2.text", "DummyFile3.text"]
    // テスト用のRealmオブジェクトとファイルを作成
    setupTestData()
  }
  
  override func tearDown() {
    sut = nil
    realm = nil
    fileManager = nil
    documentURL = nil
    dummyFiles = nil
    fileURLs = nil
    super.tearDown()
  }
  
  private func setupTestData() {
    // テスト用のRealmオブジェクトを作成
    try! realm.write {
      let testObject = TestRealmObject()
      realm.add(testObject)
    }
    
    // テスト用のファイルを作成
    for dummyFile in dummyFiles {
      let fileURL = documentURL.appendingPathComponent(dummyFile)
      fileURLs = [fileURL]
      
      do {
        try dummyFile.write(to: fileURL, atomically: true, encoding: .utf8)
      } catch {
        print("ダミーファイルの書き込みに失敗")
      }
    }
  }
  
  //成功の場合のテスト
  func testDeleteAllData_Success() {
    
    let result = sut.deleteAllData()
    //結果の検証
    XCTAssertTrue(result)
    
    //保存したダミーファイルが削除されているか確認
    for fileURL in fileURLs! {
      let result = fileManager.fileExists(atPath: fileURL.path)
      XCTAssertFalse(result)
    }
  }
  //ドキュメントディレクトリがすでにからの場合のテスト
  func testDeleteAllData_EmptyDirectorySuccess() {
    // Given
    // ドキュメントディレクトリを事前にクリア
    let contents = try? fileManager.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil, options: [])
    try? contents?.forEach { url in
      //efault.realmファイルは残す
      guard !url.lastPathComponent.hasPrefix("default.realm") else {
        print("ℹ️ default.realmファイルの削除はスキップします: \(url.lastPathComponent)")
        return
      }
      try fileManager.removeItem(at: url)
    }
    
    
    // When
    let result = sut.deleteAllData()
    
    // Then
    XCTAssertTrue(result)
  }
  
  func testDeleteAllData_SkipDeleteRealmData() {
    let deleteAllDataResult = sut.deleteAllData()
    XCTAssertTrue(deleteAllDataResult)
    
    do {
      // ドキュメントディレクトリ内のファイル一覧を取得
      let fileURLs = try FileManager.default.contentsOfDirectory(
        at: documentURL,
        includingPropertiesForKeys: nil,
        options: .skipsHiddenFiles
      )
      //default.realmから始まるファイルだけが残っているかどうか
      for file in fileURLs {
        let result = file.lastPathComponent.hasPrefix("default.realm")
        XCTAssertTrue(result)
      }
    }catch {
      print("ドキュメントディレクトリ内のファイル一覧取得に失敗しました: \(error)")
    }
    
  }
  //RealmObjectが存在しない場合のテスト
  func testDeleteAllData_EmptyRealmObjectSuccess() {
    //全てのRealmObjectを事前に削除
    try! realm.write {
      realm.deleteAll()
    }
    
    let result = sut.deleteAllData()
    XCTAssertTrue(result)
  }
}
