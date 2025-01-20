//
//  IndexSetter.swift
//  DietApp
//
//  Created by 川島真之 on 2023/07/08.
//

import Foundation

class IndexSetter {
  
  //月の前半か後半かによるindexの調整を行うメソッド
  //現在の日付が17日以降ならindexに1を返す
  func indexSetting(date: Date) -> Int {
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day, .month], from: date)
    if let day = components.day {
      if day >= 17 {
        return 1
      }
    }
    return 0
  }
}
