//
//  NotificationAlertString.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/05/02.
//

import Foundation

enum NotificationAlertString {

  static let okActionButtonTitle = "OK"

  enum RegisterSuccess {

    static let title = "通知を登録しました"
  }

  enum Permission {

    static let title = "通知が許可されていません"
    static let message = "設定アプリから通知を許可してください"
  }
}
