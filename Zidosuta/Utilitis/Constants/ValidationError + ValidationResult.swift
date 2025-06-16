//
//  ValidationError + ValidationResult.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/11/08.
//

import Foundation

protocol ValidationError: Swift.Error {

}

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
