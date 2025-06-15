//
//  MemoTextFieldValidation.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/11/08.
//

import Foundation

// MARK: - MemoValidator

protocol MemoValidator {

  func validate() -> ValidationResult
}

// MARK: - CompositeMemoValidator

protocol CompositeMemoValidator: MemoValidator {

  var validators: [MemoValidator] { get }
}

extension CompositeMemoValidator {

  func validate() -> ValidationResult {

    guard let result = validators.map({ $0.validate() }).first(where: { !$0.isValid }) else {
      return .valid
    }
    return result
  }
}

// MARK: - MemoValidationError

// エラーケースの定義
enum MemoValidationError: ValidationError {
  case exceedsMaximumCharacterLength
  case newLine
}

// 各エラーケースのメッセージ定義
extension MemoValidationError: LocalizedError {

  public var errorDescription: String? {
    switch self {
    case .exceedsMaximumCharacterLength:
      return "入力できる文字は３５文字までです"
    case .newLine:
      return "改行はできません"
    }
  }
}

// MARK: - MemoValidatorLogics

// 文字数が35文字を超えていないか
struct CharacterLengthValidator: MemoValidator {

  let memoString: String

  func validate() -> ValidationResult {

    let characterCount = memoString.count
    if characterCount > 35 {
      return .invalid(MemoValidationError.exceedsMaximumCharacterLength)
    }
    return .valid
  }
}
// 改行をしていないか
struct NewLineValidator: MemoValidator {

  let memoString: String

  func validate() -> ValidationResult {

    if memoString.contains("\n") {
      return .invalid(MemoValidationError.newLine)
    }
    return .valid
  }
}

// MARK: - MemoInputValidator

// validatorをまとめる
struct MemoInputValidator: CompositeMemoValidator {

  var validators: [MemoValidator]

  init(text: String) {
    self.validators = [
      CharacterLengthValidator(memoString: text),
      NewLineValidator(memoString: text)
    ]
  }
}
