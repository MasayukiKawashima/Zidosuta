//
//  ShadowLayerView.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/12/03.
//

import UIKit

class ShadowLayerView: UIView {
  
  
  // MARK: - Properties
  
  override var bounds: CGRect {
    didSet {
      setupShadow()
    }
  }
  
  
  // MARK: - Methods
  
  private func setupShadow() {
    
    self.layer.cornerRadius = 8
    self.layer.shadowOffset = CGSize(width: 0, height: 0)
    self.layer.shadowRadius = 3
    self.layer.shadowOpacity = 0.1
    self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
    self.layer.shouldRasterize = true
    self.layer.rasterizationScale = UIScreen.main.scale
  }
}

