//
//  ValidationResult.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/03/30.
//

import Foundation

enum ValidationResult {
  case valid
  case invalid(ValidationError)
}

extension ValidationResult {

  var isValid: Bool {
    switch self {
    case .valid:
      return true
    case .invalid:
      return false
    }
  }
}
