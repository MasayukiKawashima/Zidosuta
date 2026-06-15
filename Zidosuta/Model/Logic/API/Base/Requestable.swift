//
//  Requestable.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/06/15.
//

import Foundation

protocol Requestable {

  associatedtype Response: Decodable
  associatedtype HTTPBody: Encodable

  var baseURL: String { get }
  var path: String? { get }
  var method: HTTPMethod { get }
  var headers: [String: String]? { get }
  var body: HTTPBody? { get }
}
