//
//  DataDeleteManager.swift
//  DietApp
//
//  Created by 川島真之 on 2024/12/15.
//

import Foundation
import RealmSwift

class DataDeleteManager {
  
  static let shared = DataDeleteManager()
  private let fileManager = FileManager.default
  private let realm = try! Realm()
  private init() {}
  
  private func clearDocumentDirectroy() -> Bool {
    do {
      //ドキュメントディレクトリのパスを取得
      guard let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("❌ ドキュメントディレクトリが見つかりません")
        return false }
      //ドキュメントディレクトリ内の全てのアイテムを取得
      let contents = try fileManager.contentsOfDirectory(at: documentPath, includingPropertiesForKeys: nil, options: [])
      
      if contents.isEmpty {
        print("ℹ️ ドキュメントディレクトリは既に空です")
        return true
      }
      
      try contents.forEach { url in
        
        guard !url.lastPathComponent.hasPrefix("default.realm") else {
          print("ℹ️ default.realmファイルはスキップします: \(url.lastPathComponent)")
          return
        }
        
        try fileManager.removeItem(at: url)
        print("✅ ドキュメントディレクトリ内の全ファイル削除成功: \(url.lastPathComponent)")
      }
      
      return true
      //エラー処理
    } catch {
      print("❌ ディレクトリファイルの削除中にエラーが発生しました: \(error.localizedDescription)")
      return false
    }
  }
  
  private func deleteRealmObject() -> Bool {
    
    if realm.isEmpty {
      print("ℹ️ Realmデータベースは既に空です")
      return true
    }
     
    do {
      try realm.write {
        realm.deleteAll()
        print("✅ 全てRealmObjectの削除成功")
      }
    } catch {
      print("❌ RealmObjectの削除ができませんでした: \(error.localizedDescription)")
      return false
    }
    return true
  }
  
  func deleteAllData() -> Bool {
    let DeleteRealmObjectResult = deleteRealmObject()
    let clearDocumentDirectoryResult = clearDocumentDirectroy()
    
    if DeleteRealmObjectResult && clearDocumentDirectoryResult {
      return true
    }
    return false
  }
}
