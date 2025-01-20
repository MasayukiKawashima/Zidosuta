//
//  WeightTextFieldValidation.swift
//  DietApp
//
//  Created by 川島真之 on 2024/11/08.
//

import Foundation


// MARK: - WeightValidator

protocol WeightValidator {
  
  func validate() -> ValidationResult
}


// MARK: - CompositeWeightValidator

protocol CompositeWeightValidator: WeightValidator {
  
  var validators: [WeightValidator] { get }
}

extension CompositeWeightValidator {
  
  func validate() -> ValidationResult {
    
    guard let result = validators.map({ $0.validate() }).first(where: { !$0.isValid }) else {
      return .valid
    }
    return result
  }
}


// MARK: - WeightValidationError

//体重textField
//エ-ラケースの定義
enum WeightValidationError: ValidationError{
  case invalidFormat
  case negativeNumber
  case exceedsAllowedDecimalPlaces
  case weightInputTooHigh
}
//各エラーケースのメッセージの定義
extension WeightValidationError: LocalizedError {
  
  public var errorDescription: String? {
    switch self {
    case .invalidFormat:
      return "無効な値が入力されました"
    case .negativeNumber:
      return "マイナスの数字は入力できません"
    case .exceedsAllowedDecimalPlaces:
      return "小数点以下は１桁までです"
    case .weightInputTooHigh:
      return "体重の入力上限は300kgです"
    }
  }
}


// MARK: - WeightValidatorLogics

//検証ロジックの実装
//入力された値が適正な形式かどうか
struct WeightFormatValidator: WeightValidator {
  
  let weightString: String
  
   func validate() -> ValidationResult {
    let pattern = "^-?\\d*\\.?\\d*$"
    if weightString.range(of: pattern, options: .regularExpression) == nil {
      return .invalid(WeightValidationError.invalidFormat)
    }
    return .valid
  }
}
//マイナスの値であるかどうか
struct NegativeNumberValidator: WeightValidator {
  
  let weightString: String
  
  func validate() -> ValidationResult {
    //空文字はパス
    if weightString.isEmpty {
      return .valid
    }
    
    guard let weightInt = Double(weightString) else {
      print(" NegativeNumberValidatorで変換エラー発生")
      return .invalid(WeightValidationError.invalidFormat)
    }
    
    if weightInt < 0 {
      return .invalid(WeightValidationError.negativeNumber)
    }
    return .valid
  }
}
//小数点以下が１桁までであるかどうか
struct DecimalPlacesValidator: WeightValidator {
  
  let weightString: String
  
  func validate() -> ValidationResult {
    //空文字はパス
    if weightString.isEmpty {
      return .valid
    }
    
    let pattern = "^\\d+(\\.\\d{1})?$"
    if weightString.range(of: pattern, options: .regularExpression) == nil {
      return .invalid(WeightValidationError.exceedsAllowedDecimalPlaces)
    }
    return .valid
  }
}

//入力上限値を超えていないかどうか
struct MaxWeightValidator: WeightValidator {
  
  let weightString: String
  func validate() -> ValidationResult {
    //空文字はパス
    if weightString.isEmpty {
      return .valid
    }
    guard let weightInt = Double(weightString) else {
      print("MaxWeightValidatorで変換エラー発生")
      return .invalid(WeightValidationError.invalidFormat)
    }
    
    if weightInt > 300 {
      return .invalid(WeightValidationError.weightInputTooHigh)
    }
    return .valid
  }
}


// MARK: - WeightInputValidator

//検証構造体をまとめる
struct WeightInputValidator: CompositeWeightValidator {
  
  var validators: [WeightValidator]
  init(text: String) {
    self.validators = [
      WeightFormatValidator(weightString: text),
      NegativeNumberValidator(weightString: text),
      DecimalPlacesValidator(weightString: text),
      MaxWeightValidator(weightString: text)
    ]
  }
}
