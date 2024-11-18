//
//  PhotoTableViewCell.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/28.
//

import UIKit

protocol PhotoTableViewCellDelegate {
  func insertButtonAction()
  func expandButtonAction(photoImage: UIImage)
  func deleteButtonAction()
  func photoDoubleTapAction(photoImage: UIImage)
}
//このエクステンションの記述場所は後日変更
extension UIButton {
  /// ボタンにすりガラスエフェクトを適用する
  /// - Parameters:
  ///   - style: ブラーエフェクトのスタイル（デフォルトは.light）
  ///   - alpha: エフェクトの透明度（デフォルトは0.5）
  ///   - cornerRadius: 角丸の半径（デフォルトはボタンの幅の半分）
  func applyFrostedGlassEffect(
    _ style: UIBlurEffect.Style = .light,
    _ alpha: CGFloat = 0.5,
    _ cornerRadius: CGFloat? = nil
  ) {
    // 既存のフロストエフェクトを削除（重複防止）
    self.subviews.forEach { subview in
      if subview is UIVisualEffectView {
        subview.removeFromSuperview()
      }
    }
    
    // ぼかし効果を持つビューを作成
    let frostedEffect = UIVisualEffectView(effect: UIBlurEffect(style: style))
    frostedEffect.frame = self.bounds
    
    // 角丸の設定
    let radius = cornerRadius ?? self.frame.size.width / 2
    frostedEffect.layer.cornerRadius = radius
    frostedEffect.clipsToBounds = true
    
    // ぼかし効果のユーザーインタラクションを無効にする
    frostedEffect.isUserInteractionEnabled = false
    
    // UIButtonの背景をクリアに設定
    self.backgroundColor = .clear
    
    // ぼかし効果の透明度を設定
    frostedEffect.alpha = alpha
    
    // ぼかし効果をボタンの上に追加
    self.insertSubview(frostedEffect, at: 0)
  }
  
  /// すりガラスエフェクトを削除する
  func removeFrostedGlassEffect() {
    self.subviews.forEach { subview in
      if subview is UIVisualEffectView {
        subview.removeFromSuperview()
      }
    }
  }
  //ボタンを丸くする
  func setCornerRadius(_ cornerRadius: CGFloat? = nil) {
    let radius = cornerRadius ?? self.frame.size.width / 2
    self.layer.cornerRadius = radius
    self.clipsToBounds = true
  }
}

class PhotoTableViewCell: UITableViewCell {
  
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var insertButton: UIButton!
  @IBOutlet weak var commentLabel: UILabel!
  @IBOutlet weak var redoButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var expandButton: UIButton!
  
  var isRedoButtonConfigured = false
  var isdeleteButtonConfigured = false
  var isexpandButtontonConfigured = false
  
  var delegate: PhotoTableViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    //systemImageのサイズ調整
    let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 40)
    let image = insertButton.image(for: .normal)?.withConfiguration(symbolConfiguration)
    insertButton.setImage(image, for: .normal)
    
    insertButton.imageView?.contentMode = .scaleAspectFit
    
    redoButton.isHidden = true
    deleteButton.isHidden = true
    expandButton.isHidden = true
    
    //ボタンのサイズ調整
    if let image = image {
      let buttonSize = CGSize(width: image.size.width + 20, height: image.size.height + 20)
      insertButton.frame = CGRect(origin: insertButton.frame.origin, size: buttonSize)
    }else{
      return
    }
    setupPhotoDoubleTapGesture()
  }

  override func layoutSubviews() {
    //各種ボタンのUI設定
    super.layoutSubviews()
    if !isRedoButtonConfigured {
      redoButton.setCornerRadius()
      redoButton.applyFrostedGlassEffect()
      isRedoButtonConfigured = true
    }
    if !isdeleteButtonConfigured {
      deleteButton.setCornerRadius()
      deleteButton.applyFrostedGlassEffect()
      isdeleteButtonConfigured = true
    }
    if !isexpandButtontonConfigured {
      expandButton.applyFrostedGlassEffect()
      expandButton.setCornerRadius()
      isexpandButtontonConfigured = true
    }
    
  }

  //写真がダブルタップを感知できるようにする処理
  func setupPhotoDoubleTapGesture() {
    // ダブルタップジェスチャーの作成
    let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(photoDoubleTapAction))
    // タップ回数を2回に設定
    doubleTapGesture.numberOfTapsRequired = 2
    
    // ImageViewのユーザーインタラクションを有効化
    photoImageView.isUserInteractionEnabled = true
    // ジェスチャーをImageViewに追加
    photoImageView.addGestureRecognizer(doubleTapGesture)
  }
  
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  @IBAction func insertButtonAction(_ sender: Any) {
    delegate?.insertButtonAction()
  }
  
  @IBAction func redoButtonAction(_ sender: Any) {
    delegate?.insertButtonAction()
  }
  @IBAction func expandButtonAction(_ sender: Any) {
    if let image = photoImageView.image  {
      delegate?.expandButtonAction(photoImage: image)
    }else {
      return
    }
  }
  
  @IBAction func deleteButtonAction(_ sender: Any) {
  }
  
  @objc func  photoDoubleTapAction() {
    if let image = photoImageView.image  {
      delegate?.photoDoubleTapAction(photoImage: image)
    }else {
      return
    }
  }
}
