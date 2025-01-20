//
//  MainBackgroundView.swift
//  DietApp
//
//  Created by 川島真之 on 2024/12/03.
//

import UIKit

class MainBackgroundView: UIView {
  
  
  // MARK: - Properties
  
  override var bounds: CGRect {
    didSet {
      setupMainBackgroundView()
    }
  }
  
  
  // MARK: - Methods
  
  private func setupMainBackgroundView() {
    
    self.layer.cornerRadius = 8
    self.layer.masksToBounds = true
    self.backgroundColor = .OysterWhite
  }
}
