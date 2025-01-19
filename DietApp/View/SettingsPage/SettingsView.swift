//
//  SettingsView.swift
//  DietApp
//
//  Created by 川島真之 on 2023/06/09.
//

import UIKit

class SettingsView: UIView {
  
  
  // MARK: - Properties
  
  let cellIdentifiers = ["NotificationTableViewCell", "DeleteDataTableViewCell", "TermsOfUseTableViewCell", "PrivacyPolicyTableViewCell", "ContactTableViewCell"]
  
  @IBOutlet weak var tableView: UITableView!{
    didSet{
      //各セルの登録
      for identifier in cellIdentifiers {
        let nib = UINib(nibName: identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.backgroundColor = .systemGray6
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
      }
    }
  }
  @IBOutlet weak var copyrightView: UIView!
  
  @IBOutlet weak var versionLabel: UILabel! {
    didSet {
      versionLabel.textColor = .darkGray
    }
  }
  @IBOutlet weak var copyrightLabel: UILabel! {
    didSet {
      copyrightLabel.textColor = .darkGray
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
  
  func nibInit() {
    
    //xibファイルのインスタンス作成
    let nib = UINib(nibName: "SettingsView", bundle: nil)
    guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
    //viewのサイズを画面のサイズと一緒にする
    view.frame = self.bounds
    //サイズの自動調整
    view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    tableView.separatorStyle = .none
    self.addSubview(view)
  }
}
