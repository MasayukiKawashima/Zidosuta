//
//  MonthAdjuster.swift
//  DietApp
//
//  Created by 川島真之 on 2023/08/06.
//

import Foundation

class MonthAdjuster  {
  func adjustMonth (index: Int, date: Date = Date()) ->  Date  {
    
    let calendar = Calendar.current
    //現在の日付を取得
    //月の更新
    let value:Int!
    //indexの値が偶数＝月の前半なら
    if index % 2 == 0 {
      value = index/2
    }else{
      //indexの値が奇数＝月の後半なら
      value = (index - 1)/2
    }
    
    let modifiedDate = calendar.date(byAdding: .month, value: value, to: date)!
    return modifiedDate
  }
}
