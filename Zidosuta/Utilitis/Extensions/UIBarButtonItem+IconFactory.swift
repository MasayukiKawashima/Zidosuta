//
//  UIBarButtonItem+IconFactory.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/05/28.
//

import Foundation
import UIKit

extension UIBarButtonItem {

  // iOS25以前用: 丸背景付きアイコン
  static func roundedIcon(
    systemName: String,
    size: CGFloat = 36,
    iconColor: UIColor,
    backgroundColor: UIColor,
    directionTag: Int? = nil,
    target: Any?,
    action: Selector
  ) -> UIBarButtonItem {

    let button = UIButton(type: .system)
    let config = UIImage.SymbolConfiguration(pointSize: size * 0.4, weight: .medium)
    button.setImage(UIImage(systemName: systemName, withConfiguration: config), for: .normal)
    button.tintColor = iconColor
    button.frame = CGRect(x: 0, y: 0, width: size, height: size)
    button.backgroundColor = backgroundColor
    button.layer.cornerRadius = size / 2
    button.layer.masksToBounds = true
    if let directionTag {
      button.tag = directionTag
    }
    button.addTarget(target, action: action, for: .touchUpInside)

    return UIBarButtonItem(customView: button)
  }

  // iOS26以降用: LiquidGlass付きアイコン
  @available(iOS 26, *)
  static func liquidGlassIcon(
    systemName: String,
    iconColor: UIColor,
    directionTag: Int? = nil,
    target: Any?,
    action: Selector
  ) -> UIBarButtonItem {

    let image = UIImage(systemName: systemName)?
      .withTintColor(iconColor, renderingMode: .alwaysOriginal)

    let item = UIBarButtonItem(image: image, style: .plain, target: target, action: action)
    if let directionTag {
      item.tag = directionTag
    }
    item.adjustLiquidGlass()

    return item
  }
}
