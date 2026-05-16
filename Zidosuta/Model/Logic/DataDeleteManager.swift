//
//  DataDeleteManager.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/12/15.
//

import Foundation
import RealmSwift

actor DataDeleteManager {


  // MARK: - Properties

  static let shared = DataDeleteManager()
  private let fileManager = FileManager.default


  // MARK: - Init

  private init() {}


  // MARK: - Methods

  private func clearDocumentDirectory() -> Bool {

    do {
      // ドキュメントディレクトリのパスを取得
      guard let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("❌ ドキュメントディレクトリが見つかりません")
        return false }
      // ドキュメントディレクトリ内の全てのアイテムを取得
      let contents = try fileManager.contentsOfDirectory(at: documentPath, includingPropertiesForKeys: nil, options: [])

      if contents.isEmpty {
        print("ℹ️ ドキュメントディレクトリは既に空です")
        return true
      }

      try contents.forEach { url in
        guard !url.lastPathComponent.hasPrefix("default.realm") else {
          print("ℹ️ default.realmファイルの削除はスキップします: \(url.lastPathComponent)")
          return
        }

        try fileManager.removeItem(at: url)
        print("✅ ドキュメントディレクトリ内の全ファイル削除成功: \(url.lastPathComponent)")
      }

      return true
      // エラー処理
    } catch {
      print("❌ ディレクトリファイルの削除中にエラーが発生しました: \(error.localizedDescription)")
      return false
    }
  }

  private func deleteRealmObject() -> Bool {
    do {
      let realm = try Realm() // メソッド実行スレッド上で生成
      if realm.isEmpty {
        print("ℹ️ Realmデータベースは既に空です")
        return true
      }
      try realm.write {
        realm.deleteAll()
      }
      return true
    } catch {
      print("❌ RealmObjectの削除ができませんでした: \(error.localizedDescription)")
      return false
    }
  }

  private func removeNotificationRequests() async {

      let center = UNUserNotificationCenter.current()
      let requests = await center.pendingNotificationRequests()
      if !requests.isEmpty {
          center.removeAllPendingNotificationRequests()
      }
  }

  func deleteAllData() async -> Bool {

    let DeleteRealmObjectResult = deleteRealmObject()
    await removeNotificationRequests()
    let clearDocumentDirectoryResult = clearDocumentDirectory()
    if DeleteRealmObjectResult && clearDocumentDirectoryResult {
      return true
    }
    return false
  }
}
