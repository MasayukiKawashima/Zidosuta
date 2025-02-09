//
//  TermsDisplayViewController.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/12/19.
//

import UIKit
import WebKit

class TermsDisplayViewController: UIViewController {
  
  
  // MARK: - Properties
  
  private let termsDisplayView =  TermsDisplayView()
  
  var termsType: TermsType!
  //インジケーター
  private let indicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large) // largeスタイルに変更
    indicator.hidesWhenStopped = true
    indicator.color = .gray // 必要に応じて色を調整
    return indicator
  }()
  
  
  // MARK: - Enums
  
  enum TermsType {
    case termsOfUse
    case privacyPolicy
    
    var url: URL? {
      switch self {
      case .termsOfUse:
        return URL(string: "https://www.notion.so/1619e6db1ebc801297fdfef8e61cc911")
      case .privacyPolicy:
        return URL(string: "https://www.notion.so/1619e6db1ebc801097eed65897bb162f")
      }
    }
  }
  
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    termsDisplayView.webView.navigationDelegate = self
    
    view.addSubview(indicator)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
    
    loadContent()
    // Do any additional setup after loading the view.
  }
  
  override func loadView() {
    
    super.loadView()
    view = termsDisplayView
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    cleanupWebView()
  }
  
  
  // MARK: - Methods
  
  private func loadContent() {
    
    if let url = termsType.url {
      let request = URLRequest(url: url)
      termsDisplayView.webView.load(request)
    }
  }
  
  //WebViewが使用するリソースの解放処理
  //ログの警告を非表示にするための処理
  private func cleanupWebView() {
    
    let webView = termsDisplayView.webView!
    // 読み込みを停止
    webView.stopLoading()
    
    // キャッシュをクリア
    if #available(iOS 9.0, *) {
      WKWebsiteDataStore.default().removeData(
        ofTypes: [WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache],
        modifiedSince: Date(timeIntervalSince1970: 0),
        completionHandler: { }
      )
    }
    // 空のページを読み込んでリソースを解放
    webView.loadHTMLString("", baseURL: nil)
  }
  
  deinit {
    termsDisplayView.webView.navigationDelegate = nil
    termsDisplayView.webView.uiDelegate = nil
  }
}


// MARK: - WKNavigationDelegate

//WKWebViewでのWebコンテンツのナビゲーション（読み込みやリダイレクトなど）を制御・監視するデリゲートメソッド
extension TermsDisplayViewController: WKNavigationDelegate {
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    
    indicator.startAnimating()
  }
  
  // WebViewの読み込み完了時
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    
    indicator.stopAnimating()
  }
  
  // WebViewの読み込み失敗時
  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    
    indicator.stopAnimating()
  }
}
