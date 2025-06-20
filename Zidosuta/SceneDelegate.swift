//
//  SceneDelegate.swift
//  Zidosuta
//
//  Created by 川島真之 on 2023/05/16.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  // MARK: - Properties

  var window: UIWindow?

  // MARK: - LifeCycle

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    routeToAppropriateScreen(scene)
  }

  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }

  // MARK: - Methods

  // 初回起動かどうかで最初に表示する画面を分岐させるメソッド
  private func routeToAppropriateScreen(_ scene: UIScene) {

    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    self.window = window

    // UserDefaultsで初回起動判定
    let isFirstLaunch = !UserDefaults.standard.bool(forKey: "didCompleteFirstLaunch")

    if isFirstLaunch {
      // 初回起動時：オンボード画面を表示
      let onboardingView = OnboardingView() // SwiftUIのView
      let onboardingViewController = UIHostingController(rootView: onboardingView)
      window.rootViewController = onboardingViewController

    } else {
      // 2回目以降：メインコンテンツを表示
      let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
      if let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
        window.rootViewController = tabBarController
      }
    }
    window.makeKeyAndVisible()
  }
}
