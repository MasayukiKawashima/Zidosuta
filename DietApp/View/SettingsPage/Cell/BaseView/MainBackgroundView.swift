//
//  MainBackgroundView.swift
//  DietApp
//
//  Created by 川島真之 on 2024/12/03.
//

import UIKit

class MainBackgroundView: UIView {
  
  override var bounds: CGRect {
    didSet {
      setupMainBackgroundView()
    }
  }

  func setupMainBackgroundView() {
    self.layer.cornerRadius = 8
    self.layer.masksToBounds = true
    self.backgroundColor = .OysterWhite
  }
  
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
