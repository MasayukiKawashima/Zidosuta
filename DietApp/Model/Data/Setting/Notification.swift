//
//  Notification.swift
//  DietApp
//
//  Created by 川島真之 on 2024/12/08.
//

import Foundation
import RealmSwift

class Notification: Object {
  @Persisted var notificationTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date()
  @Persisted var isNotificationEnabled: Bool = false
  
  convenience init(time: Date, isEnabled: Bool) {
    self.init()
    self.notificationTime = time
    self.isNotificationEnabled = isEnabled
  }
}
