//
//  EmailAlertString.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/05/01.
//

import Foundation

enum EmailAlertString {

  static let okActionButtonTitle = "OK"

  enum SendFailure {

    static let alertTitle = "メール機能が使えません"
  }

  enum SendSuccess {

    static let alertTitle = "メールを送信しました"
  }

  enum Unavailable {

    static let alertTitle = "メールを送信できませんでした"
  }
}
