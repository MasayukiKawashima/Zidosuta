//
//  LocalNotificationManager.swift
//  DietApp
//
//  Created by 川島真之 on 2024/12/10.
//

import Foundation
import RealmSwift
import SwiftUI
import UserNotifications

class LocalNotificationManager {
  
  
  // MARK: - Properties
  
  static let shared = LocalNotificationManager()
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
  
  
  // MARK: - Methods
  
  //ユーザーに通知の許可を確認するメソッド
  func requestAuthorization(completion: @escaping (Bool) -> Void) {
    
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) { granted, error in
      //ユーザーからの通知許可の返答を待つ
      DispatchQueue.main.async {
        completion(granted)
      }
    }
  }
  //通知をスケジュールするメソッド
  //このモデルを使用するオブジェクトで呼ばれるメソッド
  func setScheduleNotification() {
    
    let center = UNUserNotificationCenter.current()
    let isEnabled = currentSettings.isNotificationEnabled
    
    center.getPendingNotificationRequests { requests in
      center.removeAllPendingNotificationRequests()
      center.removeAllDeliveredNotifications()
      
      // 削除完了後に新しい通知をスケジュール
      DispatchQueue.main.async {
        if isEnabled {
          self.scheduleNotification(hour: self.currentSettings.hour,
                                    minute: self.currentSettings.minute)
        }
      }
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
    content.title = "ジドスタ"
    content.body = "記録時間の通知です"
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
  
  //ボタンや通知自体をタップした時にアプリのトップ画面に飛ばす処理
  func navigateToTopScreen() {
    
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first {
      
      let didCompleteOnboarding = UserDefaults.standard.bool(forKey: "didCompleteFirstLaunch")
      
      if !didCompleteOnboarding {
        // オンボーディングが未完了の場合、オンボーディング画面を表示
        let onboardVC = OnboardingView() // あなたのオンボーディング画面のビューコントローラー
        window.rootViewController = UIHostingController(rootView: onboardVC)
        window.makeKeyAndVisible()
        return
      }
      
      // ルートビューコントローラーがUITabBarControllerであることを確認
      guard let tabBarController = window.rootViewController as? UITabBarController else {
        print("Error: Root view controller is not UITabBarController")
        return
      }
      
      // 目的の画面があるタブを選択（通常は最初のタブ）
      tabBarController.selectedIndex = 0
      
      // 選択されたタブのビューコントローラーがUINavigationControllerであることを確認
      guard let navController = tabBarController.selectedViewController as? UINavigationController else {
        print("Error: Selected view controller is not UINavigationController")
        return
      }
      
      // ナビゲーションスタックのルートまで戻る（途中の画面をクリア）
      navController.popToRootViewController(animated: false)
      
      // トップのビューコントローラーがUIPageViewControllerであることを確認
      guard let pageViewController = navController.topViewController as? UIPageViewController else {
        print("Error: Top view controller is not UIPageViewController")
        return
      }
      
      // 新しいTopViewControllerをインスタンス化して表示
      let topVC = TopViewController()
      pageViewController.setViewControllers([topVC],
                                            direction: .forward,
                                            animated: false)
    } else {
      print("Error: Could not find window scene")
    }
  }
}
