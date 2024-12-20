//
//  TermsDisplayViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2024/12/19.
//

import UIKit

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
