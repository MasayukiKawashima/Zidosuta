//
//  TopNavigationController.swift
//  Zidosuta
//
//  Created by 川島真之 on 2023/06/20.
//

import UIKit

class TopNavigationController: UINavigationController {

  // MARK: - LifeCycle

  override func viewDidLoad() {

    super.viewDidLoad()

    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.YellowishRed

    self.navigationBar.standardAppearance = appearance
    self.navigationBar.scrollEdgeAppearance = appearance
    self.navigationController?.navigationBar.compactAppearance = appearance

  }
}
