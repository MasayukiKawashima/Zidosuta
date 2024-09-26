//
//  UITabBarController+Orientation.swift
//  DietApp
//
//  Created by 川島真之 on 2023/06/07.
//

import Foundation
import UIKit

extension UITabBarController {

  open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if let VC = selectedViewController {
      return VC.supportedInterfaceOrientations
    }else{
      return .portrait
    }
  }
}
