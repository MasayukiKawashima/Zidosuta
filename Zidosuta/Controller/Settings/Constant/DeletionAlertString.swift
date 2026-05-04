//
//  DeletionAlertString.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/05/02.
//

import Foundation

enum DeletionAlertString {

  static let okActionTitle = "OK"

  enum Confirmation {

    static let title =  "警告"
    static let message = "全てのデータを削除してもよろしいですか \nこの操作は取り消せません"
    static let cancelActionTitle = "キャンセル"
    static let deleteActionTitle = "削除する"
  }

  enum DeletionCompleted {

    static let message = "全てのデータが削除されました"
  }

  enum DeletionFailed {

    static let message = "データの削除に失敗しました"
  }
}
