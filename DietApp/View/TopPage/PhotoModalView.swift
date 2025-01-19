//
//  PhotoModalView.swift
//  DietApp
//
//  Created by 川島真之 on 2024/10/18.
//

import UIKit


// MARK: - PhotoModalViewDelegate

protocol PhotoModalViewDelegate {
  func dismiss()
}


// MARK: - PhotoModalView

class PhotoModalView: UIView {
  
  
  // MARK: - Properties
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var dismissButton: UIButton!
  var  isDismissButtonConfigured = false
  
  var delegate: PhotoModalViewDelegate?
  
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.nibInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.nibInit()
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
  
  // MARK: - LifeCycle
  
  override func layoutSubviews() {
    
    super.layoutSubviews()
    if !isDismissButtonConfigured {
      dismissButton.applyFrostedGlassEffect()
      dismissButton.setCornerRadius()
      isDismissButtonConfigured = true
    }
  }
  
  override  func awakeFromNib() {
    
    //シンボルのサイズ設定
    let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 60)
    let image = dismissButton.image(for: .normal)?.withConfiguration(symbolConfiguration)
    dismissButton.setImage(image, for: .normal)
  }
  
  
  // MARK: - Methods
  
  @IBAction func dismissButtonAction(_ sender: Any) {
    
    delegate?.dismiss()
  }
}
