//
//  DateRangeCalculator.swift
//  DietApp
//
//  Created by 川島真之 on 2023/07/26.
//

import Foundation

class DateRangeCalculator {
  
  func calculateMonthHalfDayRange(index: Int,  date: Date = Date()) -> (startDay: Int, endDay: Int) {
    
    let calendar = Calendar.current
    //現在の日付を取得
    //月の更新
    let value = (index - 1)/2
    let modifiedDate = calendar.date(byAdding: .month, value: value, to: date)!
    
    var startDay: Int
    var endDay: Int
    
    if index % 2 == 0 {
      //indexが偶数だったら
      startDay = 1
      endDay = 16
    } else {
      //indexが奇数だったら
      startDay = 17
      
      let range = calendar.range(of: .day, in: .month, for: modifiedDate)!
      //現在の月の最終日をendDayに代入
      endDay = range.count
    }
    return (startDay: startDay, endDay: endDay)
  }
}

