//
//  UIBarButtonItem+LiquidGlassSupporting.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/05/25.
//

import Foundation
import UIKit

extension UIBarButtonItem: LiquidGlassSupporting {

  func applyLiquidGlass() {
    if #available(iOS 26, *) {
      tintColor = .YellowishRed
    }
  }

  func revertLiquidGlass() {
    if #available(iOS 26.0, *) {
      hidesSharedBackground = true
    }
  }
}
