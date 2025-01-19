//
//  LocalNotificationManagerTests.swift
//  DietAppTests
//
//  Created by 川島真之 on 2025/01/01.
//

import XCTest
@testable import DietApp

class LocalNotificationManagerTests: XCTestCase {
  
  
  // MARK: - Properties
  
    var notificationManager: LocalNotificationManager!
    var notificationCenter: UNUserNotificationCenter!
  
  
  // MARK: - Methods
    
    override func setUp() {
      
        super.setUp()
      
        notificationManager = LocalNotificationManager.shared
        notificationCenter = UNUserNotificationCenter.current()
    }
    
    override func tearDown() {
      
        notificationCenter.removeAllPendingNotificationRequests()
      
        super.tearDown()
    }
    
  
  // MARK: - TestCases
  
    func testSetScheduleNotification() {
      
        let expectation = XCTestExpectation(description: "Notification scheduled")
        
        notificationManager.setScheduleNotification()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.notificationCenter.getPendingNotificationRequests { requests in
                // テスト1: 通知リクエストが登録できているか
                XCTAssertTrue(requests.contains { $0.identifier == "dailyReminder" })
                
                // テスト2: 保留中のリクエスト数が1つであるか
                XCTAssertEqual(requests.count, 1)
                
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
