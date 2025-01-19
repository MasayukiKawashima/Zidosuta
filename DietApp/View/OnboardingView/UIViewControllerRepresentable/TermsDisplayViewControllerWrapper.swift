//
//  TermsDisplayViewControllerWrapper.swift
//  DietApp
//
//  Created by 川島真之 on 2025/01/05.
//

import Foundation
import SwiftUI

struct TermsDisplayViewControllerWrapper: UIViewControllerRepresentable {
  
  
  // MARK: - Properties
  
  let termsType: TermsDisplayViewController.TermsType
  
  
  // MARK: - Methods
  
  func makeUIViewController(context: Context) -> TermsDisplayViewController {
    
    let viewController = TermsDisplayViewController()
    viewController.termsType = termsType
    return viewController
  }
  
  func updateUIViewController(_ uiViewController: TermsDisplayViewController, context: Context) {
    
  }
}
