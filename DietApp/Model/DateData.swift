//
//  DateData.swift
//  DietApp
//
//  Created by 川島真之 on 2023/06/29.
//

import Foundation
import RealmSwift

class DateData: Object {
  @objc dynamic var date: Date = Date()
  @objc dynamic var weight: String = ""
  @objc dynamic var memoText: String = ""
  @objc dynamic var fileURL: String = ""
  @objc dynamic var photoOrientation: String = ""
}
