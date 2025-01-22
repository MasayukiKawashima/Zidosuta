//
//  DateData.swift
//  Zidosuta
//
//  Created by 川島真之 on 2023/06/29.
//

import Foundation
import RealmSwift

class DateData: Object {
  
  @objc dynamic var date: Date = Date()
  @objc dynamic var weight: Double = 0
  @objc dynamic var memoText: String = ""
  @objc dynamic var photoFileURL: String = ""
  @objc dynamic var imageOrientationRawValue: Int = Int()
}
