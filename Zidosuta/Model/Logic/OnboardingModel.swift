//
//  OnboardingModel.swift
//  Zidosuta
//
//  Created by 川島真之 on 2025/06/02.
//


import SwiftUI
import UIKit

class OnboardingModel: ObservableObject {
  
  func transitionToMainContent() {
    
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first {
      let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
      if let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
        window.rootViewController = tabBarController
        
        let snapshot = UIScreen.main.snapshotView(afterScreenUpdates: true)
        window.addSubview(snapshot)
        UIView.animate(withDuration: 0.5, animations: {
          snapshot.alpha = 0
        }, completion: { _ in
          snapshot.removeFromSuperview()
        })
      }
    }
  }
  
  func completeFirstLaunch() {
    
    UserDefaults.standard.set(true, forKey: "didCompleteFirstLaunch")
  }
}
