//
//  WeightTextFieldValidationTest.swift
//  ZidosutaTests
//
//  Created by 川島真之 on 2024/11/08.
//

import XCTest
@testable import Zidosuta

final class WeightTextFieldValidationTest: XCTestCase {
  
  
  // MARK: - TestCases
  
  //WeightFormatValidator
  //このvalodatorにおいて有効な値のテスト
  //-50や50.55は最終的には無効な値だが、このvalidatorにおいては有効
  func testWeightFormatValidator_ValidInput_ShouldReturnValid() {
    
    let validInputs = ["50", "0", "-50", "50.5", "50.55"]
    
    validInputs.forEach { input in
      let validator = WeightFormatValidator(weightString: input)
      let result = validator.validate()
      XCTAssertTrue(result.isValid, "Input \(input) は無効な値です")
    }
  }
  
  //無効な値
  func testWeightFormatValidator_InvalidInput_ShouldReturnInvalid() {
    
    let invalidInputs = ["abc", "12.34.56", "@@", "50kg","😄"]
    
    invalidInputs.forEach { input in
      let validator = WeightFormatValidator(weightString: input)
      let result = validator.validate()
      XCTAssertFalse(result.isValid)
      //let result = validator.validate()でresultが.invalidの場合、その関連値（WeightValidationErrorのいずれかのケース）が
      //.invalid(let error)のerrorに代入
      if case .invalid(let error) = result {
        //errorのWeightValidationErrorのケースが.invalidFormatになっているかを確認
        //.invalidFormatになっていない　＝　エラーケースの種類違いということになる
        XCTAssertEqual(error as? WeightValidationError, WeightValidationError.invalidFormat)
      }
    }
  }
  
  //NegativeNumberValidator
  //有効な値かどうかを確認
  func testNegativeNumberValidator_ValidInput_ShouldReturnValid() {
    
    let validInputs = ["50", "0", "50.5", "50.55", ""]
    
    validInputs.forEach { input in
      let validator = NegativeNumberValidator(weightString: input)
      let result = validator.validate()
      XCTAssertTrue(result.isValid, "Input \(input) は無効な値です")
    }
  }
  
  //無効な値
  func testNegativeNumberValidator_InvalidInput_ShouldReturnInvalid() {
    
    let invalidInputs = ["-1", "-50", "-50.5"]
    
    invalidInputs.forEach { input in
      let validator = NegativeNumberValidator(weightString: input)
      let result = validator.validate()
      XCTAssertFalse(result.isValid)
      if case .invalid(let error) = result {
        XCTAssertEqual(error as? WeightValidationError, WeightValidationError.negativeNumber)
      }
    }
  }
  
  //テキストがDouble型に変換できない場合
  func testNegativeNumberValidator_NumberConversionFails_ShouldReturnInvalidFormat() {
    
    let invalidConversionInputs = [ "abc", "  ", "1.1.1", "😄"]
    
    invalidConversionInputs.forEach { input in
      let validator = NegativeNumberValidator(weightString: input)
      let result = validator.validate()
      
      XCTAssertFalse(result.isValid, "Input '\(input)' should be invalid")
      if case .invalid(let error) = result {
        XCTAssertEqual(error as? WeightValidationError, WeightValidationError.invalidFormat,
                       "Input '\(input)' はエラー（invalidFormat）を返すべきです")
      } else {
        XCTFail("Doubleに変換できています: \(input)")
      }
    }
  }
  
  //DecimalPlacesValidator
  //有効な値
  func testDecimalPlacesValidator_ValidInput_ShouldReturnValid() {
    
    let validInputs = ["50", "50.5", "0.0", ""]
    
    validInputs.forEach { input in
      let validator = DecimalPlacesValidator(weightString: input)
      let result = validator.validate()
      XCTAssertTrue(result.isValid, "Input \(input) は無効な値です")
    }
  }
  
  //無効な値
  func testDecimalPlacesValidator_InvalidInput_ShouldReturnInvalid() {
    
    let invalidInputs = ["50.55", "50.00", "0.123"]
    
    invalidInputs.forEach { input in
      let validator = DecimalPlacesValidator(weightString: input)
      let result = validator.validate()
      XCTAssertFalse(result.isValid)
      if case .invalid(let error) = result {
        XCTAssertEqual(error as? WeightValidationError, WeightValidationError.exceedsAllowedDecimalPlaces)
      }
    }
  }
  
  //testMaxWeightValidator
  //有効な値
  func testMaxWeightValidator_ValidInput_ShouldReturnValid() {
    
    let validInputs = ["50", "299", "0", "300", ""]
    
    validInputs.forEach { input in
      let validator = MaxWeightValidator(weightString: input)
      let result = validator.validate()
      XCTAssertTrue(result.isValid, "Input \(input) は無効な値です")
    }
  }
  
  //無効な値
  func testMaxWeightValidator_InvalidInput_ShouldReturnInvalid() {
    
    let invalidInputs = ["301", "500"]
    
    invalidInputs.forEach { input in
      let validator = MaxWeightValidator(weightString: input)
      let result = validator.validate()
      XCTAssertFalse(result.isValid)
      if case .invalid(let error) = result {
        XCTAssertEqual(error as? WeightValidationError, WeightValidationError.weightInputTooHigh)
      }
    }
  }
  
  //テキストがDouble型に変換できない場合
  func testMaxWeightValidator_NumberConversionFails_ShouldReturnInvalidFormat() {
    
    let invalidConversionInputs = [ "abc", "  ", "1.1.1", "😄"]
    
    invalidConversionInputs.forEach { input in
      let validator = MaxWeightValidator(weightString: input)
      let result = validator.validate()
      
      XCTAssertFalse(result.isValid, "Input '\(input)' should be invalid")
      if case .invalid(let error) = result {
        XCTAssertEqual(error as? WeightValidationError, WeightValidationError.invalidFormat,
                       "Input '\(input)' はエラー（invalidFormat）を返すべきです")
      } else {
        XCTFail("Doubleに変換できています: \(input)")
      }
    }
  }
  
  
  //testWeightInputValidator
  //各validatorの総合テスト
  //有効な値
  func testWeightInputValidator_ValidInput_ShouldReturnValid() {
    
    let validInputs = ["50", "50.5", "299.9", "0.0"]
    
    validInputs.forEach { input in
      let validator = WeightInputValidator(text: input)
      let result = validator.validate()
      XCTAssertTrue(result.isValid, "Input \(input) は無効な値です")
    }
  }
  
  //無効な値
  func testWeightInputValidator_InvalidInput_ShouldReturnInvalid() {
    
    let testCases = [
      ("abc", WeightValidationError.invalidFormat),
      ("-1", WeightValidationError.negativeNumber),
      ("50.55", WeightValidationError.exceedsAllowedDecimalPlaces),
      ("301", WeightValidationError.weightInputTooHigh)
    ]
    
    testCases.forEach { input, expectedError in
      let validator = WeightInputValidator(text: input)
      let result = validator.validate()
      XCTAssertFalse(result.isValid)
      if case .invalid(let error) = result {
        XCTAssertEqual(error as? WeightValidationError, expectedError)
      }
    }
  }
}
