//
//  TermsDisplayViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2024/12/19.
//

import UIKit
import WebKit

class TermsDisplayViewController: UIViewController {
  
  let termsDisplayView =  TermsDisplayView()
  
  var termsType: TermsType!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
  
  enum TermsType {
    case termsOfUse
    case privacyPolicy
    
    var url: URL? {
      switch self {
      case .termsOfUse:
        return URL(string: "https://night-beryl-de2.notion.site/DietApp-1619e6db1ebc801297fdfef8e61cc911?pvs=4")
      case .privacyPolicy:
        return URL(string: "https://night-beryl-de2.notion.site/DietApp-1619e6db1ebc801097eed65897bb162f?pvs=4")
      }
    }
  }
  
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
