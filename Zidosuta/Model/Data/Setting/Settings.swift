//
//  Settings.swift
//  DietApp
//
//  Created by 川島真之 on 2024/12/08.
//

import Foundation
import RealmSwift

class Settings: Object {
  @Persisted var id: String = "settings"
  @Persisted var notification: Notification?
  
  override static func primaryKey() -> String? {
    return "id"
  }
  //このモデルはレコードが複数存在したらまずいので、シングルトンにする
  static let shared: Settings = {
    let realm = try! Realm()
    // 既存のSettingsを取得、なければ新規作成
    if let existingSettings = realm.object(ofType: Settings.self, forPrimaryKey: "settings") {
      return existingSettings
    } else {
      let settings = Settings()
      let notification = Notification()
      
      try! realm.write {
        realm.add(notification)
        settings.notification = notification
        realm.add(settings)
      }
      return settings
    }
  }()
  
  func update(operation: (Settings) -> Void) {
    let realm = try! Realm()
    try! realm.write {
      operation(self)
    }
  }
}
