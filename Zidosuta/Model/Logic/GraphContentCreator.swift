//
//  GraphContentCreator.swift
//  Zidosuta
//
//  Created by 川島真之 on 2023/07/17.
//

import Foundation
import RealmSwift
import Charts

class GraphContentCreator {
  
  
  // MARK: - Properties
  
  private let realm: Realm!
  
  private let currentDate: Date!
  
  
  // MARK: - Init
  
  init(realm: Realm = try! Realm(), currentDate: Date = Date()){
    
    self.realm = realm
    self.currentDate = currentDate
  }
  
  
  // MARK: - Methods
  
  //エントリーポイントを作成するメソッド
  func createDataEntry(index: Int) -> [ChartDataEntry] {
    
    let calendar = Calendar.current
    
    let monthAdjuster = MonthAdjuster()
    let modifiedDate = monthAdjuster.adjustMonth(index: index, date: currentDate)
    
    //現在の日付の月と年を取得
    let month = calendar.component(.month, from: modifiedDate)
    let year = calendar.component(.year, from: modifiedDate)
    
    let dateRangeCalculator = DateRangeCalculator()
    let range = dateRangeCalculator.calculateMonthHalfDayRange(index: index, date: currentDate)
    
    var dataEntries: [ChartDataEntry] = []
    
    for day in range.startDay...range.endDay {
      //現在の年、月、日を表すDateを作成。時間はその日の開始時刻(0時0分0秒）を取得。
      let startOfCurrentDay = calendar.date(from: DateComponents(calendar: calendar, timeZone: TimeZone.current, year: year, month: month, day: day))!
      //startOfCurrentDayに1日を足した日を作成。時間は開始時刻。
      let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfCurrentDay)!
      // 指定した日付のエントリを検索
      let results = self.realm.objects(DateData.self)
        .filter("date >= %@ && date < %@ && weight != 0", startOfCurrentDay, startOfNextDay)
      
      // すべての結果をループし、チャートエントリーを作成
      for result in results {
        let entry = ChartDataEntry(x: Double(day), y: result.weight)
        dataEntries.append(entry)
      }
    }
    return dataEntries
  }
}
