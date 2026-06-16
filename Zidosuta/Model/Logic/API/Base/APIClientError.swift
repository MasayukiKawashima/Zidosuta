//
//  APIClientError.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/06/15.
//

import Foundation

enum APIClientError: Error {
  
  case invalidURL
  case encodingError(Error)
  case decodingError(Error)
  case invalidResponse
  case serverError(statusCode: Int)
  case networkError(Error)
}
