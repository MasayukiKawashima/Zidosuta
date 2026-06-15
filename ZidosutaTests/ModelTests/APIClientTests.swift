//
//  APIClientTests.swift
//  ZidosutaTests
//
//  Created by 川島真之 on 2026/06/15.
//

import XCTest
@testable import Zidosuta

class APIClientTests: XCTestCase {


  // MARK: - Properties

  private var mockSession: MockURLSession!
  private var apiClient: APIClient!


  // MARK: - Methods

  override func setUp() {

    super.setUp()
    mockSession = MockURLSession()
    apiClient = APIClient(session: mockSession)
  }

  override func tearDown() {

    mockSession = nil
    apiClient = nil

    super.tearDown()
  }


  // MARK: - TestCases

  // 通信成功時にレスポンスが正しくデコードされることをテスト
  func testRequestSuccess() async throws {

    let json = "{\"value\":\"hello\"}".data(using: .utf8)!
    mockSession.stubbedData = json
    mockSession.stubbedResponse = HTTPURLResponse(
      url: URL(string: "https://example.com/")!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )!

    let result = try await apiClient.request(MockRequest())
    XCTAssertEqual(result.value, "hello")
  }

  // ステータスコードが2xx以外の場合にserverErrorが投げられることをテスト
  func testRequestServerError() async {

    mockSession.stubbedData = Data()
    mockSession.stubbedResponse = HTTPURLResponse(
      url: URL(string: "https://example.com/")!,
      statusCode: 500,
      httpVersion: nil,
      headerFields: nil
    )!

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

    mockSession.stubbedData = "invalid json".data(using: .utf8)!
    mockSession.stubbedResponse = HTTPURLResponse(
      url: URL(string: "https://example.com/")!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )!

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

    mockSession.stubbedError = URLError(.notConnectedToInternet)

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

    mockSession.stubbedData = Data()
    mockSession.stubbedResponse = URLResponse(
      url: URL(string: "https://example.com/")!,
      mimeType: nil,
      expectedContentLength: 0,
      textEncodingName: nil
    )

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

// URLSessionProtocolのモック。任意のdata/response/errorを返せる
private class MockURLSession: URLSessionProtocol {

  var stubbedData: Data?
  var stubbedResponse: URLResponse?
  var stubbedError: Error?

  func data(for request: URLRequest) async throws -> (Data, URLResponse) {

    if let error = stubbedError {
      throw error
    }
    return (stubbedData ?? Data(), stubbedResponse ?? URLResponse())
  }
}

// テスト用のRequestable実装
private struct MockRequest: Requestable {

  typealias Response = MockResponse
  typealias HTTPBody = EmptyBody

  var baseURL: URL { URL(string: "https://example.com/")! }
  var path: String { "test" }
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
