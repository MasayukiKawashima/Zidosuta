//
//  ZidosutaUpdatesRequest.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/06/15.
//

import Foundation

struct ZidosutaUpdatesRequest: Requestable {

  typealias Response = ZidosutaUpdatesResponse
  typealias HTTPBody = EmptyBody

  var baseURL: String { ZidosutaUpdatesAPIConstants.url }
  var path: String?
  var method: HTTPMethod { ZidosutaUpdatesAPIConstants.method }
  var headers: [String : String]?
  var body: HTTPBody?
}
