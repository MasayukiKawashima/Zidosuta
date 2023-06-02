//
//  GraphView.swift
//  DietApp
//
//  Created by 川島真之 on 2023/06/01.
//

import UIKit

class GraphView: UIView {
  
  @IBOutlet weak var navigationBar: UINavigationBar!
  
  @IBOutlet weak var navigationItem: UINavigationItem!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.nibInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.nibInit()
  }
  
  func nibInit() {
    //xibファイルのインスタンス作成
    let nib = UINib(nibName: "GraphView", bundle: nil)
    guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
    //viewのサイズを画面のサイズと一緒にする
    view.frame = self.bounds
    //サイズの自動調整
    view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    
    self.addSubview(view)
  }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
