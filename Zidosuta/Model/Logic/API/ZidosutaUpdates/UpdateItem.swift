//
//  UpdateItem.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/06/19.
//

import Foundation

struct UpdateItem: Hashable {

  let id: UUID
  let version: String
  let description: String
  let releaseDate: String
}
