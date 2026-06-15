//
//  APIClient.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/06/15.
//

import Foundation

class APIClient {

  private let session: URLSessionProtocol

  init(session: URLSessionProtocol = URLSession.shared) {

    self.session = session
  }

  func request<T: Requestable>(_ request: T) async throws -> T.Response {

    let url: URL
    // URLの組み立て
    if let path = request.path {
      if let combinedURL = URL(string: path, relativeTo: request.baseURL) {
        url = combinedURL
      } else {
        throw APIClientError.invalidURL
      }
    } else {
      url = request.baseURL
    }

    // URLRequestの構築
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.method.rawValue
    if let headers = request.headers {
      for (key, value) in headers {
        urlRequest.setValue(value, forHTTPHeaderField: key)
      }
    }

    // Bodyのエンコード
    if let body = request.body {
      do {
        urlRequest.httpBody = try JSONEncoder().encode(body)
      } catch {
        throw APIClientError.encodingError(error)
      }
    }

    // 通信実行
    let data: Data
    let response: URLResponse
    do {
      (data, response) = try await session.data(for: urlRequest)
    } catch {
      throw APIClientError.networkError(error)
    }

    // レスポンスの検証
    guard let httpResponse = response as? HTTPURLResponse else {
      throw APIClientError.invalidResponse
    }
    guard (200..<300).contains(httpResponse.statusCode) else {
      throw APIClientError.serverError(statusCode: httpResponse.statusCode)
    }

    // レスポンスのデコード
    do {
      return try JSONDecoder().decode(T.Response.self, from: data)
    } catch {
      throw APIClientError.decodingError(error)
    }
  }
}
