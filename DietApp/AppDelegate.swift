//
//  AppDelegate.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/16.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  
  // MARK: - Properties
  
  var window: UIWindow?
  
  
  // MARK: - Methods
  
  //画面の向きを設定するメソッド
  func supportedInterfaceOrientationsForTopViewController(window: UIWindow?) -> UIInterfaceOrientationMask {
    
    if let rootViewController = window?.rootViewController {
      // TabBarControllerを取得
      if let tabBarController = rootViewController as? UITabBarController {
        // まず選択されたViewControllerを取得
        if let selectedNavController = tabBarController.selectedViewController as? UINavigationController {
          // 選択されたNavigationControllerのトップViewControllerを取得
          if let topViewController = selectedNavController.topViewController {
            // 向きを返す
            return topViewController.supportedInterfaceOrientations
          }
        }
      }
    }
    // デフォルトは縦向き
    return .portrait 
  }
  
  
  // MARK: - LifeCycle
  
  //ViewControllerの向きの設定
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    
    supportedInterfaceOrientationsForTopViewController(window: window)
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    //スプラッシュ画面を1秒表示する
    let splashScreenDuration: UInt32 = 1
    sleep(splashScreenDuration)
    
    let config = Realm.Configuration(
      schemaVersion: 1,
      migrationBlock: { migration, oldSchemaVersion in
        // マイグレーションが必要な場合はここに記述
      }
    )
    Realm.Configuration.defaultConfiguration = config
    
    // 通知デリゲートの設定
    UNUserNotificationCenter.current().delegate = self
    // 通知機能がオンなら保存された通知設定を復元
    LocalNotificationManager.shared.restoreNotificationIfNeeded()
    
    return true
  }
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  
  // ユーザーが通知に対してアクションをとった時に呼ばれるデリゲートメソッド
  // center: 通知を管理するUNUserNotificationCenterのインスタンス
  // response: ユーザーの応答情報を含むオブジェクト
  // completionHandler: 処理完了時に必ず呼び出す必要があるクロージャー
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    
    // ユーザーが選択したアクションのタイプに基づいて処理を分岐
    switch response.actionIdentifier {
    case "RECORD_ACTION":  // レコードアクションが選択された場合
      LocalNotificationManager.shared.navigateToTopScreen()
    case "LATER_ACTION":  // 後で見るアクションが選択された場合
      print("Later action selected")
      break  // 特に追加の処理は必要なし
      
      //通知自体をタップした時の処理
    default:
      LocalNotificationManager.shared.navigateToTopScreen()
      break
    }
    // 処理完了をシステムに通知
    // この呼び出しを忘れるとアプリがクラッシュする可能性がある
    completionHandler()
  }
  
  //フォアグラウンドで通知を受信した時の処理
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    
    // フォアグラウンドでも通知を表示する
    completionHandler([.banner])
  }
}
