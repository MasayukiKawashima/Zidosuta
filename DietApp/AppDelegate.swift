//
//  AppDelegate.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/16.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    return true
  }
  //ViewControllerの向きの設定
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
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
    //設定画面はまだNavigationConrtrollerを実装していないので、デフォルトの向きになる
    //デフォルトをportraitにすることでも期待した動作をしているが、ロジックが汚いので修正予定
    return .portrait // デフォルトの向き
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

