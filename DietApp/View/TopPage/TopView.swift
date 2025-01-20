//
//  TopView.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/26.
//

import UIKit

class TopView: UIView {
  
  
  // MARK: - Properties
  
  private let cellIdentifiers = ["WeightTableViewCell","MemoTableViewCell","PhotoTableViewCell","AdTableViewCell"]
  
  @IBOutlet weak var tableView: UITableView! {
    didSet{
      //各セルの登録
      for identifier in cellIdentifiers {
        let nib = UINib(nibName: identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
      }
    }
  }
  
  
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    
    super.init(frame: frame)
    self.nibInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
    self.nibInit()
  }
  
  // MARK: - Methods
  
  private func nibInit() {
    
    //xibファイルのインスタンス作成
    let nib = UINib(nibName: "TopView", bundle: nil)
    guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
    //viewのサイズを画面のサイズと一緒にする
    view.frame = self.bounds
    //サイズの自動調整
    view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    
    self.addSubview(view)
  }
}
