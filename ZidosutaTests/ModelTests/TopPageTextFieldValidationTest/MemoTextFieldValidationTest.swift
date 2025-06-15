//
//  MemoTextFieldValidationTest.swift
//  ZidosutaTests
//
//  Created by 川島真之 on 2024/11/10.
//

import XCTest
@testable import Zidosuta

final class MemoTextFieldValidationTest: XCTestCase {

  // MARK: - TestCases

  // CharacterLengthValidator
  // 有効な値
  func testCharacterLengthValidator_ValidInput_ShouldReturnValid() {

    let validInputs = ["あ",
                       "あいうえお",
                       "aiueo",
                       // ３5文字
                       "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめも",
                       // 34文字
                       "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめ",
                       " ",
                       "",
                       "123"
    ]

    validInputs.forEach { input in
      let validator = CharacterLengthValidator(memoString: input)
      let result = validator.validate()
      XCTAssertTrue(result.isValid, "Input \(input) は無効な値です")
    }
  }

  // 無効な値
  func testCharacterLengthValidator_InvalidInput_ShouldReturnInvalid() {

    // 36文字
    let invalidInputs = ["あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもや",
                         // 46文字
                         "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへもまみむめもやゆよらりるれろわをん"
    ]

    invalidInputs.forEach { input in
      let validator = CharacterLengthValidator(memoString: input)
      let result = validator.validate()
      XCTAssertFalse(result.isValid)
    }
  }

  // NewLineValidator
  // 有効な値
  func testNewLineValidator_ValidInput_ShouldReturnValid() {

    let validInputs = ["あ",
                       "あいうえお",
                       "あ　いうえお",
                       "123",
                       "aiu",
                       " ",
                       ""
    ]

    validInputs.forEach { input in
      let validator = NewLineValidator(memoString: input)
      let result = validator.validate()
      XCTAssertTrue(result.isValid, "Input \(input) は無効な値です")
    }
  }

  // 無効な値
  func testNewLineValidator_InvalidInput_ShouldReturnInvalid() {

    let invalidInputs = ["\n",
                         "\nあいうえお",
                         "あいうえお\nかきくけこ",
                         "あいうえお\n",
                         "あいうえお\nかきくけこ\nさしすせそ"
    ]

    invalidInputs.forEach { input in
      let validator = NewLineValidator(memoString: input)
      let result = validator.validate()
      XCTAssertFalse(result.isValid)
    }
  }

  func testMemoInputValidator_ValidInput_ShouldReturnValid() {

    let validInputs = ["あいうえおかきくけこ",
                       "あいうえお　かきくけこ",
                       "aiu",
                       "123",
                       " ",
                       ""
    ]

    validInputs.forEach { input in
      let validator = MemoInputValidator(text: input)
      let result = validator.validate()
      XCTAssertTrue(result.isValid, "Input \(input) は無効な値です")
    }
  }

  func testMemovalidator_InvalidInput_ShouldReturnInvalid() {

    let testCases = [
      ("あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへもまみむめもやゆよらりるれろわをん", MemoValidationError.exceedsMaximumCharacterLength),
      ("あいうえお\nかきくけこ\nさしすせそ", MemoValidationError.newLine)
    ]

    testCases.forEach { input, expectedError in
      let validator = MemoInputValidator(text: input)
      let result = validator.validate()
      XCTAssertFalse(result.isValid)
    }
  }
}
