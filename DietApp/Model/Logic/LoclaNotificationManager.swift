//
//  LoclaNotificationManager.swift
//  DietApp
//
//  Created by 川島真之 on 2024/12/10.
//

import Foundation
import RealmSwift
import UserNotifications

class LoclaNotificationManager {
  static let shared = LoclaNotificationManager()
  //外部からのインスタンス化を防ぐための空初期化子
  private init() {}
  //Realmインスタンスを保持
  private var realm: Realm {
    do {
      return try Realm()
    } catch {
      fatalError ("Realmの初期化に失敗しました: \(error)")
    }
  }
  //現在の設定情報を保持
  var currentSettings: Notification {
    let settings = Settings.shared
    return settings.notification!
  }
  
  /// 通知の許可を要求
  /// - Parameter completion: 許可状態を返すクロージャ
  func requestAuthorization(completion: @escaping (Bool) -> Void) {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      //ユーザーからの通知許可の返答を待つ
      DispatchQueue.main.async {
        completion(granted)
      }
    }
  }
  //通知をスケジュールするメソッド
  //このモデルを使用するオブジェクトで呼ばれるメソッド
  func setScheduleNotification(date: Date, isEnabled: Bool) {
    
    //既存の通知を消去
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    //通知がオンなら通知をスケジュール
    if isEnabled {
      scheduleNotification(hour: currentSettings.hour, minute: currentSettings.minute)
    }
  }
  //スケジュールの再設定
  func restoreNotificationIfNeeded() {
    if currentSettings.isNotificationEnabled {
      scheduleNotification(hour: currentSettings.hour, minute: currentSettings.minute)
    }
  }
  //スケジュールをする内部メソッド
  private func scheduleNotification(hour: Int, minute: Int) {
    //通知の定義
    let content = UNMutableNotificationContent()
    content.title = "記録時間の通知"
    content.body = "今日の記録をしましょう"
    content.sound = .default
    
    // アクションボタンの定義
    let recordAction = UNNotificationAction(
      identifier: "RECORD_ACTION",
      title: "記録する",
      options: .foreground
    )
    
    let laterAction = UNNotificationAction(
      identifier: "LATER_ACTION",
      title: "あとで",
      options: []
    )
    
    // カテゴリの定義
    let category = UNNotificationCategory(
      identifier: "DAILY_REMINDER",
      actions: [recordAction, laterAction],
      intentIdentifiers: [],
      options: []
    )
    //カテゴリを登録
    UNUserNotificationCenter.current().setNotificationCategories([category])
    //今回の通知のカテゴリを上記のカテゴリに設定
    content.categoryIdentifier = "DAILY_REMINDER"
    
    // 毎日同じ時刻の通知トリガーを設定
    var components = DateComponents()
    components.hour = hour
    components.minute = minute
    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
    //通知リクエスト設定
    let request = UNNotificationRequest(
      identifier: "dailyReminder",
      content: content,
      trigger: trigger
    )
    //リクエストの登録
    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        print("通知のスケジュールに失敗しました: \(error)")
      }
    }
  }
}

