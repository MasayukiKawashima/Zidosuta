//
//  Date + ConvertDateToNotificationTimeString.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/12/09.
//

import Foundation
import UIKit

extension Date {
  
  func convertDateToNotificationTimeString() -> String {
    
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: self)
    let minute = calendar.component(.minute, from: self)
    let paddedHour = String(format: "%0d", hour)
    let paddedMinute = String(format: "%02d", minute)
    let combinedString = ("\(paddedHour) : \(paddedMinute)")
    return combinedString
  }
}
