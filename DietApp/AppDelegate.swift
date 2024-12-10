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
  
  var window: UIWindow?
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
    return .portrait // デフォルトは縦向き
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
  //ViewControllerの向きの設定
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    supportedInterfaceOrientationsForTopViewController(window: window)
  }
  
  // MARK: UISceneSession Lifecycle
  
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
  
  // 通知に対するユーザーのアクションを処理するデリゲートメソッド
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
      navigateToTopScreen()
    case "LATER_ACTION":  // 後で見るアクションが選択された場合
      print("Later action selected")
      break  // 特に追加の処理は必要なし
      
      //通知自体をタップした時の処理
    default:
      navigateToTopScreen()
      break
    }
    // 処理完了をシステムに通知
    // この呼び出しを忘れるとアプリがクラッシュする可能性がある
    completionHandler()
  }
  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // フォアグラウンドでも通知を表示する
    completionHandler([.banner])
  }
}
//ボタンや通知自体をタップした時にアプリのトップ画面に飛ばす処理
private func navigateToTopScreen() {
  if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
     let window = windowScene.windows.first {
    
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


