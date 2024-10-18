//
//  PhotoModalView.swift
//  DietApp
//
//  Created by 川島真之 on 2024/10/18.
//

import UIKit

class PhotoModalView: UIView {
  
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var dismissButton: UIButton!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.nibInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.nibInit()
  }
  
  override  func awakeFromNib() {
    //シンボルのサイズ設定
    let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 60)
    let image = dismissButton.image(for: .normal)?.withConfiguration(symbolConfiguration)
    dismissButton.setImage(image, for: .normal)
  }
  
  func nibInit(){
    //xibファイルのインスタンス作成
    let nib = UINib(nibName: "PhotoModalView", bundle: nil)
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
