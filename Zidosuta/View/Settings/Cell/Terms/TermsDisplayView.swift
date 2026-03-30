//
//  TermsDisplayView.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/12/19.
//

import UIKit
import WebKit

class TermsDisplayView: UIView, NibLoadable {


  // MARK: - Properties

  @IBOutlet weak var webView: WKWebView! {
    didSet {
      webView.backgroundColor = .white
    }
  }


  // MARK: - LifeCycle

  override init(frame: CGRect) {

    super.init(frame: frame)
    nibInit()
  }

  required init?(coder aDecoder: NSCoder) {

    super.init(coder: aDecoder)
    nibInit()
  }


  // MARK: - Methods

}
