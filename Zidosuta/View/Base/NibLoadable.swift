//
//  NibLoadable.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/03/30.
//

import Foundation
import UIKit

protocol NibLoadable where Self: UIView {

  static var nibName: String { get }
}

extension NibLoadable {

  static var nibName: String {
    return String(describing: Self.self)
  }

  func nibInit() {

    let nib = UINib(nibName: Self.nibName, bundle: nil)
    guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
      print("nibの初期化失敗：\(Self.nibName)")
      return
    }
    view.frame = self.bounds
    view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    self.addSubview(view)
  }
}
