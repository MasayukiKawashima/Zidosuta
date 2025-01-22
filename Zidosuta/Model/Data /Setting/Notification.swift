//
//  Notification.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/12/08.
//

import Foundation
import RealmSwift

class Notification: Object {
  
  
  // MARK: - Properties
  
  @Persisted var notificationTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date()
  @Persisted var hour: Int = 9
  @Persisted var minute: Int = 0
  @Persisted var isNotificationEnabled: Bool = false
  
  
  // MARK: - Init
  
  convenience init(time: Date, isEnabled: Bool) {
    
    self.init()
    self.notificationTime = time
    self.isNotificationEnabled = isEnabled
  }
}
