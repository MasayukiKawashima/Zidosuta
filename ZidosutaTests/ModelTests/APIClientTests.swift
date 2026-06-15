//
//  APIClientTests.swift
//  ZidosutaTests
//
//  Created by 川島真之 on 2026/06/15.
//

import XCTest
@testable import Zidosuta

class APIClientTests: XCTestCase {

  // MARK: - Helpers

  private func makeHTTPResponse(statusCode: Int) -> HTTPURLResponse {
    HTTPURLResponse(
      url: URL(string: "https://example.com/")!,
      statusCode: statusCode,
      httpVersion: nil,
      headerFields: nil
    )!
  }

  // MARK: - TestCases

  // 通信成功時にレスポンスが正しくデコードされることをテスト
  func testRequestSuccess() async throws {

    let json = "{\"value\":\"hello\"}".data(using: .utf8)!
    let mockSession = MockURLSession(
      data: json,
      response: makeHTTPResponse(statusCode: 200)
    )
    let apiClient = APIClient(session: mockSession)

    let result = try await apiClient.request(MockRequest())
    XCTAssertEqual(result.value, "hello")
  }

  // ステータスコードが2xx以外の場合にserverErrorが投げられることをテスト
  func testRequestServerError() async {

    let mockSession = MockURLSession(
      data: Data(),
      response: makeHTTPResponse(statusCode: 500)
    )
    let apiClient = APIClient(session: mockSession)

    do {
      _ = try await apiClient.request(MockRequest())
      XCTFail("エラーが投げられるはず")
    } catch APIClientError.serverError(let statusCode) {
      XCTAssertEqual(statusCode, 500)
    } catch {
      XCTFail("想定外のエラー: \(error)")
    }
  }

  // 不正なJSONを受信したときdecodingErrorが投げられることをテスト
  func testRequestDecodingError() async {

    let mockSession = MockURLSession(
      data: "invalid json".data(using: .utf8)!,
      response: makeHTTPResponse(statusCode: 200)
    )
    let apiClient = APIClient(session: mockSession)

    do {
      _ = try await apiClient.request(MockRequest())
      XCTFail("エラーが投げられるはず")
    } catch APIClientError.decodingError {
      // 成功
    } catch {
      XCTFail("想定外のエラー: \(error)")
    }
  }

  // URLSessionがエラーを投げた時にnetworkErrorが投げられることをテスト
  func testRequestNetworkError() async {

    let mockSession = MockURLSession(
      error: URLError(.notConnectedToInternet)
    )
    let apiClient = APIClient(session: mockSession)

    do {
      _ = try await apiClient.request(MockRequest())
      XCTFail("エラーが投げられるはず")
    } catch APIClientError.networkError {
      // 成功
    } catch {
      XCTFail("想定外のエラー: \(error)")
    }
  }

  // HTTPURLResponseでないレスポンスを受信したときinvalidResponseが投げられることをテスト
  func testRequestInvalidResponse() async {

    let mockSession = MockURLSession(
      data: Data(),
      response: URLResponse(
        url: URL(string: "https://example.com/")!,
        mimeType: nil,
        expectedContentLength: 0,
        textEncodingName: nil
      )
    )
    let apiClient = APIClient(session: mockSession)

    do {
      _ = try await apiClient.request(MockRequest())
      XCTFail("エラーが投げられるはず")
    } catch APIClientError.invalidResponse {
      // 成功
    } catch {
      XCTFail("想定外のエラー: \(error)")
    }
  }
}


// MARK: - Mocks

// URLSessionProtocolのモック。init時に指定したdata/response/errorを返す
private final class MockURLSession: URLSessionProtocol {

  let stubbedData: Data?
  let stubbedResponse: URLResponse?
  let stubbedError: Error?

  init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
    self.stubbedData = data
    self.stubbedResponse = response
    self.stubbedError = error
  }

  func data(for request: URLRequest) async throws -> (Data, URLResponse) {

    if let stubbedError {
      throw stubbedError
    }
    return (stubbedData ?? Data(), stubbedResponse ?? URLResponse())
  }
}

// テスト用のRequestable実装
private struct MockRequest: Requestable {

  typealias Response = MockResponse
  typealias HTTPBody = EmptyBody

  var baseURL: String { "https://example.com/" }
  var path: String? { "test" }
  var method: HTTPMethod { .get }
  var headers: [String: String]? { [:] }
  var body: EmptyBody? { nil }
}

// テスト用のレスポンス型
private struct MockResponse: Decodable {

  let value: String
}

// 空Body用のEncodable型
private struct EmptyBody: Encodable {}
