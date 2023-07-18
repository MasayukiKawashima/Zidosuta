//
//  GraphContentCreator.swift
//  DietApp
//
//  Created by 川島真之 on 2023/07/17.
//

import Foundation
import RealmSwift
import Charts

class GraphContentCreator {
  //エントリーポイントを作成するメソッド
  func createDataEntry(index: Int) -> [ChartDataEntry] {
    let realm = try! Realm()
  
    let calendar = Calendar.current
    //現在の日付を取得
    let date = Date()
    //月の更新
    let value = (index - 1)/2
    let modifiedDate = calendar.date(byAdding: .month, value: value, to: date)!
  
    //現在の日付の月と年を取得
    let month = calendar.component(.month, from: modifiedDate)
    let year = calendar.component(.year, from: modifiedDate)
    
    var startDay: Int
    var endDay: Int
    
    if index % 2 == 0 {
      //indexが偶数だったら
      startDay = 1
      endDay = 16
    } else {
      //indexが奇数だったら
      startDay = 17
      //現在の月の最終日をendDayに代入
      endDay = endOfMonth(modifiedDate)
    }

    var dataEntries: [ChartDataEntry] = []
    
    for day in startDay...endDay {
      //現在の年、月、日を表すDateを作成。時間はその日の開始時刻(0時0分0秒）を取得。
      let startOfCurrentDay = calendar.date(from: DateComponents(calendar: calendar, timeZone: TimeZone.current, year: year, month: month, day: day))!
      //startOfCurrentDayに1日を足した日を作成。時間は開始時刻。
      let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfCurrentDay)!
      // 指定した日付のエントリを検索
      let results = realm.objects(DateData.self)
        .filter("date >= %@ && date < %@ && weight != 0", startOfCurrentDay, startOfNextDay)

      // すべての結果をループし、チャートエントリーを作成
      for result in results {
        let entry = ChartDataEntry(x: Double(day), y: result.weight)
          dataEntries.append(entry)
      }
    }
    return dataEntries
  }
  //createEntryPointsのヘルパーメソッド
  //現在の月の最終日を返すメソッド
  //この処理だけ切り分ける必要があるのか後で確認
  func endOfMonth(_ date: Date) -> Int {
    let calendar = Calendar.current
    //現在の月の日数を範囲として返す
    //例えば2023年7月17日にこのメソッドを呼び出せば1..<32という値がrangeに代入される
    let range = calendar.range(of: .day, in: .month, for: date)!
    //rangeに値された範囲の要素数を返す
    //つまり上の例でいうと31を返す
    return range.count
  }
}
