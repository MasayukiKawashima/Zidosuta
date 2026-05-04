//
//  TopAlertString.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/05/03.
//

import Foundation

enum TopAlertString {

  static let okActionTitle = "OK"

  enum PhotoDelete {

    static let message = "写真を削除してもよろしいですか？"
    static let deleteActionTitle = "削除する"
    static let cancelActionTitle = "キャンセル"
  }

  enum CameraPermission {

    static let title = "カメラへのアクセスが許可されていません"
    static let message = "カメラを使用するには設定アプリからカメラへのアクセスを許可してください"
  }

  enum ValidationError {

    static let title = "入力エラー"
  }
}
