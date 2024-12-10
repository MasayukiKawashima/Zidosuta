//
//  TopDateManagerTopDateManager.swift
//  DietApp
//
//  Created by 川島真之 on 2023/08/16.
//

import Foundation

class TopDateManager {
  var date: Date!

  init(date: Date = Date()){
    self.date = date
  }
  
  func updateDate(currentDate: Date, byDays days: Int) {
    let calendar = Calendar.current
    let modifiedDate = calendar.date(byAdding: .day, value: days, to: currentDate)
    date = modifiedDate
  }
}
