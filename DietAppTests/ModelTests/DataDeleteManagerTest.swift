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
    
    override func setUp() {
        super.setUp()
        sut = DataDeleteManager.shared
        realm = try! Realm()
        fileManager = FileManager.default
        
        // テスト用のRealmオブジェクトとファイルを作成
        setupTestData()
    }
    
    override func tearDown() {
        sut = nil
        realm = nil
        fileManager = nil
        super.tearDown()
    }
    
    private func setupTestData() {
        // テスト用のRealmオブジェクトを作成
        try! realm.write {
            let testObject = TestRealmObject()
            realm.add(testObject)
        }
        
        // テスト用のファイルを作成
        if let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let testFilePath = documentPath.appendingPathComponent("testFile.txt")
            try? "Test Data".write(to: testFilePath, atomically: true, encoding: .utf8)
        }
    }
  //成功の場合のテスト
    func testDeleteAllData_Success() {
      
        let result = sut.deleteAllData()

        XCTAssertTrue(result)
        
       //念の為Realmとドキュメントディレクトリの中身が空になっているか確認
        XCTAssertEqual(realm.objects(TestRealmObject.self).count, 0)
        
        // ドキュメントディレクトリ内にファイルが存在しないことを確認
        if let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let contents = try? fileManager.contentsOfDirectory(at: documentPath, includingPropertiesForKeys: nil, options: [])
            XCTAssertTrue(contents?.isEmpty ?? false)
        }
    }
    //ドキュメントディレクトリがすでにからの場合のテスト
    func testDeleteAllData_EmptyDirectorySuccess() {
        // Given
        // ドキュメントディレクトリを事前にクリア
        if let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let contents = try? fileManager.contentsOfDirectory(at: documentPath, includingPropertiesForKeys: nil, options: [])
            try? contents?.forEach { url in
                try fileManager.removeItem(at: url)
            }
        }
        
        // When
        let result = sut.deleteAllData()
        
        // Then
        XCTAssertTrue(result)
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

