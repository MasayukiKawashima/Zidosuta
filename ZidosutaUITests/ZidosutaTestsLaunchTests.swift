//
//  ZidosutaUITestsLaunchTests.swift
//  ZidosutaUITests
//
//  Created by 川島真之 on 2023/05/16.
//

import XCTest

class ZidosutaUITestsLaunchTests: XCTestCase {

  // MARK: - Properties

  override class var runsForEachTargetApplicationUIConfiguration: Bool {
    true
  }

  // MARK: - Methods

  override func setUpWithError() throws {

    continueAfterFailure = false
  }

  // MARK: - TestCases

  func testLaunch() throws {

    let app = XCUIApplication()

    app.launch()

    // Insert steps here to perform after app launch but before taking a screenshot,
    // such as logging into a test account or navigating somewhere in the app

    let attachment = XCTAttachment(screenshot: app.screenshot())
    attachment.name = "Launch Screen"
    attachment.lifetime = .keepAlways
    add(attachment)
  }
}
