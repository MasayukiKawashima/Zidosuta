//
//  AppInfoString.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/04/17.
//

import Foundation

enum AppInfoString {

  static func makeAppVersionText() -> String {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    return "Version \(version)"
  }

  static func makeCopyrightText() -> String {
    let year = Calendar.current.component(.year, from: Date())
    return "© \(year) Masayuki Kawashima"
  }
}
