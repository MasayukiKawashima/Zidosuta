//
//  AppDelegateTests.swift
//  DietAppTests
//
//  Created by 川島真之 on 2024/09/27.
//

import XCTest
@testable import DietApp

final class AppDelegateTests: XCTestCase {
  
  var appDelegate: AppDelegate!
  var window: UIWindow!
  var tabBarController: TabBarController!
  var topNavigationController: TopNavigationController!
  var topPageviewController: TopPageViewController!
  var topViewController: TopViewController!
  var graphNavigationController: GraphNavigationController!
  var graphPageViewController: GraphPageViewController!
  var graphViewController: GraphViewController!
  var settingsNavigationController: SettingsNavigationController!
  var settingsViewController: SettingsViewController!
  
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
  
  override func setUp() {
    super.setUp()
    
    appDelegate = UIApplication.shared.delegate as? AppDelegate
    self.window = UIWindow()
    self.tabBarController = TabBarController()
    self.topNavigationController = TopNavigationController()
    self.topPageviewController = TopPageViewController()
    self.topViewController = TopViewController()
    self.graphNavigationController = GraphNavigationController()
    self.graphPageViewController = GraphPageViewController()
    self.graphViewController = GraphViewController()
    self.settingsNavigationController = SettingsNavigationController()
    self.settingsViewController = SettingsViewController()
  }
  
  override func tearDown() {
  }
}

extension AppDelegateTests {
  //supportedInterfaceOrientationsForTopViewController(window: )のテスト
  //グラフページ（左横向き）のテスト
  func testGraphPage() {
    graphNavigationController.viewControllers = [graphViewController]
    tabBarController.viewControllers = [graphNavigationController]
    window.rootViewController = tabBarController
    
    let result = appDelegate.supportedInterfaceOrientationsForTopViewController(window: window)
    XCTAssertEqual(result, .landscapeLeft)
  }
  //トップページ（縦向き）のテスト
  func testTopPage() {
    topNavigationController.viewControllers = [topViewController]
    tabBarController.viewControllers = [topNavigationController]
    window.rootViewController = tabBarController
    
    let result = appDelegate.supportedInterfaceOrientationsForTopViewController(window: window)
    XCTAssertEqual(result, .portrait)
  }
  
  //設定ページ（縦向き)のテスト
  func testSettingsPage() {
    settingsNavigationController.viewControllers = [settingsViewController]
    tabBarController.viewControllers = [settingsNavigationController]
    window.rootViewController = tabBarController
    
    let result = appDelegate.supportedInterfaceOrientationsForTopViewController(window: window)
    XCTAssertEqual(result, .portrait)
  }
  
}
