//
//  GraphDateManager.swift
//  Zidosuta
//
//  Created by 川島真之 on 2023/08/20.
//

import Foundation

class GraphDateManager {

  // MARK: - Properties

  var firstDateOfHalfMonth: Date?
  var lastDateOfHalfMonth: Date?

  lazy var index: Int = {
    // 月の前半か後半かによるindexの調整
    let date = Date()
    let indexSetter = IndexSetter()
    return indexSetter.indexSetting(date: date)
  }()

  // MARK: - Init

  init(date: Date = Date()) {

    updateDate(index: self.index, date: date)
  }

  // MARK: - Methods

  func updateDate(index: Int, date: Date = Date()) {

    let calendar = Calendar.current
    var modifiedDate = Date()

    self.index = index

    if self.index % 2 == 0 {
      let value = self.index/2
      modifiedDate = calendar.date(byAdding: .month, value: value, to: date)!

      let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: modifiedDate))!
      let sixteenthDay = calendar.date(bySetting: .day, value: 16, of: firstDay)!

      firstDateOfHalfMonth = firstDay
      lastDateOfHalfMonth = sixteenthDay
    }else {
      let value = (self.index - 1)/2
      modifiedDate = calendar.date(byAdding: .month, value: value, to: date)!
      // modifiedDateから直接その月の17日の日付を取得しようとすると、来月になってしまう。
      // なので一旦、modifiedDateから月を抽出して、その月の最初の日を設定
      let firstDayOfMonth = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: modifiedDate))!
      // その後その月の日付を17日設定する
      let seventeenthDay = calendar.date(bySetting: .day, value: 17, of: firstDayOfMonth)!

      // 月末の取得は来月の月初を取得し、そこから１日戻すことで取得
      let add = DateComponents(month: 1, day: -1)
      let NextMonthFirstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: modifiedDate))!
      let lastDay = calendar.date(byAdding: add, to: NextMonthFirstDay)!

      firstDateOfHalfMonth = seventeenthDay
      lastDateOfHalfMonth = lastDay
    }
  }
}
