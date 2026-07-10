//
//  OnboardingModel.swift
//  Zidosuta
//
//  Created by 川島真之 on 2025/06/02.
//

import Foundation

class OnboardingModel: ObservableObject {

  func completeFirstLaunch() {

    UserDefaults.standard.set(true, forKey: "didCompleteFirstLaunch")
  }
}
