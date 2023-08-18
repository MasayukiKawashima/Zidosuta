//
//  TopDateManagerTopDateManager.swift
//  DietApp
//
//  Created by 川島真之 on 2023/08/16.
//

import Foundation

class TopDateManager {
  var dateComponents: DateComponents?
  
  init(){
    let date = Date()
    let calendar = Calendar.current
    dateComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
  }
  
  func updateDateComponets(byDays days: Int) {
    let calendar = Calendar.current
    if let date = calendar.date(from: dateComponents!) {
      
      let modifiedDate = calendar.date(byAdding: .day, value: days, to: date)
      let modifiedDateComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: modifiedDate!)
      
      dateComponents = modifiedDateComponents
    }
  }
}
