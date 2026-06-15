//
//  URLSessionProtocol.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/06/15.
//

import Foundation

// APIClientのテスト時にURLSessionをモックに差し替えるためのプロトコル
protocol URLSessionProtocol {

  func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
