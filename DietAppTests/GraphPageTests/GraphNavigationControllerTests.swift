//
//  GraphNavigationControllerTests.swift
//  DietAppTests
//
//  Created by 川島真之 on 2024/09/27.
//

import XCTest
@testable import DietApp

final class GraphNavigationControllerTests: XCTestCase {
  
  var graphNavigationController: GraphNavigationController!
  
  override  func setUp() {
    super.setUp()
    self.graphNavigationController = GraphNavigationController()
  }
  
  override func tearDown() {
    graphNavigationController = nil
    super.tearDown()
  }
  
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
}



