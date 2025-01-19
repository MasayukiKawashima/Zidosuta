//
//  TopScreenUITests.swift
//  DietAppUITests
//
//  Created by 川島真之 on 2025/01/16.
//

import XCTest

final class TopScreenUITests: XCTestCase {
  
  
  // MARK: - Properties
  
  let app = XCUIApplication()
  
  
  // MARK: - Methods
  
  override func setUp() {
    
    super.setUp()
    continueAfterFailure = false
    app.launch()
  }
  
  
  // MARK: - TestCases
  
  //weightTextField
  //体重テキストフィールドに入力した際に入力値がテキストフィールド上に表示されているかどうか
  func testWeightTextFieldInput() {
    
    let textField = app.textFields["weightTextField"]
    XCTAssert(textField.exists)
    
    textField.tap()
    
    let inputText = "60"
    textField.typeText(inputText)
    
    XCTAssertEqual(textField.value as? String, inputText)
  }
  
  //写真セットボタンが押されたときにアクションシートが表示されるかのテスト
  func testActionSheetPresentation() {
    
    let button = app.buttons["insertButton"]
    XCTAssert(button.exists)
    
    button.tap()
    
    let actionSheet = app.sheets["photoSelectionSheet"]
    let exists = NSPredicate(format: "exists == true")
    expectation(for: exists, evaluatedWith: actionSheet, handler: nil)
    waitForExpectations(timeout: 5, handler: nil)
    
    XCTAssert(actionSheet.exists)
  }
}
