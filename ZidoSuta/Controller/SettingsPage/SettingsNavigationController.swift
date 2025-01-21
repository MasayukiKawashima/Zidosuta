//
//  SettingsNavigationController.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/09/26.
//

import UIKit

class SettingsNavigationController: UINavigationController {
  
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    navigationBar.tintColor = .white
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.YellowishRed
    
    self.navigationBar.standardAppearance = appearance
    self.navigationBar.scrollEdgeAppearance = appearance
    self.navigationController?.navigationBar.compactAppearance = appearance
  }
}
