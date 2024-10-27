//
//  PhotoModalView.swift
//  DietApp
//
//  Created by 川島真之 on 2024/10/18.
//

import UIKit

protocol PhotoModalViewDelegate {
  func dismiss()
}


class PhotoModalView: UIView {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var dismissButton: UIButton!
  var  isDismissButtonConfigured = false
  
  var delegate: PhotoModalViewDelegate?
  
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
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if !isDismissButtonConfigured {
      setDismissButtonCornerRadius()
      applyFrostedGlassEffect()
      isDismissButtonConfigured = true
    }
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
  
  @IBAction func dismissButtonAction(_ sender: Any) {
    delegate?.dismiss()
  }
  
  func setDismissButtonCornerRadius() {
    dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
    dismissButton.clipsToBounds = true
  }
  
  private func applyFrostedGlassEffect() {
    // ぼかし効果を持つビューを作成
    let frostedEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    frostedEffect.frame = dismissButton.bounds
    frostedEffect.layer.cornerRadius = dismissButton.frame.size.width / 2
    frostedEffect.clipsToBounds = true
    
    // ぼかし効果のユーザーインタラクションを無効にする
    //これをしないとボタンをタップしても反応しなくなる
    //すりガラス効果がボタンの上に乗っかるのでタップイベントがボタンに届かなくなため
    frostedEffect.isUserInteractionEnabled = false
    // UIButtonの背景をクリアに設定
    dismissButton.backgroundColor = .clear
    // ぼかし効果の背景色を設定（透明度を調整）
    frostedEffect.alpha = 0.5
    // ぼかし効果をボタンの上に追加
    dismissButton.insertSubview(frostedEffect, at: 0)
  }
  
  
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */
  
}
