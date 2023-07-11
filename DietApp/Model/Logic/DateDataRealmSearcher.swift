//
//  DateDataRealmSearcher.swift
//  DietApp
//
//  Created by 川島真之 on 2023/07/10.
//

import Foundation
import RealmSwift

class DateDataRealmSearcher {
  func searchForDateDataInRealm(currentDate: Date) -> Results<DateData> {
    let realm = try! Realm()
    //日付の正規化
    let startOfDay = Calendar.current.startOfDay(for: currentDate)
    let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
    //検索
    let results = realm.objects(DateData.self).filter("date >= %@ AND date < %@", startOfDay, endOfDay)
    return results
  }
}
