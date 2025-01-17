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
  func deleteButtonAction(in cell: PhotoTableViewCell)
  func photoDoubleTapAction(photoImage: UIImage)
}
//このエクステンションの記述場所は後日変更
extension UIButton {
  //非アクティブ状態のボタンの外観の設定
  func configureDisabledButtonAppearance() {
    self.tintColor = UIColor.systemGray.withAlphaComponent(0.3)
    self.backgroundColor = UIColor.systemGray5
  }
  //アクティブ状態のボタンの外観の設定
  func configureEnabledButtonAppearance() {
    self.tintColor = UIColor.systemBlue
    self.backgroundColor = nil
    applyFrostedGlassEffect()
  }
  
  /// ボタンにすりガラスエフェクトを適用する
  /// - Parameters:
  ///   - style: ブラーエフェクトのスタイル（デフォルトは.light）
  ///   - alpha: エフェクトの透明度（デフォルトは0.5）
  ///   - cornerRadius: 角丸の半径（デフォルトはボタンの幅の半分）
  func applyFrostedGlassEffect(
    _ style: UIBlurEffect.Style = .light,
    _ alpha: CGFloat = 0.8,
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
  @IBOutlet weak var insertButton: UIButton! {
    didSet {
      insertButton.accessibilityIdentifier = "insertButton"
    }
  }
  @IBOutlet weak var commentLabel: UILabel!
  @IBOutlet weak var redoButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var expandButton: UIButton!

  var delegate: PhotoTableViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    commentLabel.adjustsFontSizeToFitWidth = true
    commentLabel.minimumScaleFactor = 0.5
    
    photoImageView.backgroundColor = UIColor.OysterWhite
    //photoImageViewのimageを監視する
    //imageの値が変わるたびにnilが代入されたか否かで分岐して処理を行う
    photoImageView.addObserver(self, forKeyPath: #keyPath(UIImageView.image), options: [.new, .old], context: nil)
   //各種ボタンの初期設定
    let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 40)
    let image = insertButton.image(for: .normal)?.withConfiguration(symbolConfiguration)
    insertButton.setImage(image, for: .normal)
    insertButton.imageView?.contentMode = .scaleAspectFit

    let radius = insertButton.frame.size.width / 2
    insertButton.layer.cornerRadius = radius
    insertButton.backgroundColor = UIColor.white
    
    insertButton.layer.shadowColor = UIColor.gray.cgColor  // 影の色
    insertButton.layer.shadowOffset = CGSize(width: 0, height: 1)  // 影のオフセット
    insertButton.layer.shadowRadius =  1  // 影のぼかし具合
    insertButton.layer.shadowOpacity = 0.5  // 影の透明度
    
//    if let imageView = insertButton.imageView {
//      imageView.layer.shadowColor = UIColor.gray.cgColor
//      imageView.layer.shadowOpacity = 0.5
//      imageView.layer.shadowOffset = CGSize(width: 0, height: 1)
//      imageView.layer.shadowRadius = 1.5
//    }
//    
    redoButton.setCornerRadius()
    redoButton.configureDisabledButtonAppearance()
    
    deleteButton.setCornerRadius()
    deleteButton.configureDisabledButtonAppearance()
    
    expandButton.setCornerRadius()
    expandButton.configureDisabledButtonAppearance()

    redoButton.isUserInteractionEnabled = false
    deleteButton.isUserInteractionEnabled = false
    expandButton.isUserInteractionEnabled = false
    //ボタンのサイズ調整
    if let image = image {
      let buttonSize = CGSize(width: image.size.width + 20, height: image.size.height + 20)
      insertButton.frame = CGRect(origin: insertButton.frame.origin, size: buttonSize)
    }else{
      return
    }
    setupPhotoDoubleTapGesture()
  }
  //photoImageView.imageの値が変わるたびに呼び出される処理
  //nilが代入されたか否かで分岐して処理する
  override  func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard keyPath == #keyPath(UIImageView.image) else { return }
    
    if let _ = change?[.newKey] as? UIImage {
      //nilじゃない値がセットされた場合　＝　画像がセットされたら
      self.insertButton.isHidden = true
      self.commentLabel.isHidden = true
      self.redoButton.configureEnabledButtonAppearance()
      self.redoButton.isUserInteractionEnabled = true
      self.deleteButton.configureEnabledButtonAppearance()
      self.deleteButton.isUserInteractionEnabled = true
      self.expandButton.configureEnabledButtonAppearance()
      self.expandButton.isUserInteractionEnabled = true
      print("Aの処理: 画像がセットされました")
    } else {
      //nilがセットされた場合　＝　画像を削除した時
      self.insertButton.isHidden = false
      self.commentLabel.isHidden = false
      self.redoButton.configureDisabledButtonAppearance()
      self.redoButton.isUserInteractionEnabled = false
      self.deleteButton.configureDisabledButtonAppearance()
      self.deleteButton.isUserInteractionEnabled = false
      self.expandButton.configureDisabledButtonAppearance()
      self.expandButton.isUserInteractionEnabled = false
      print("Bの処理: 画像がnilになりました")
    }
  }
  deinit {
    photoImageView.removeObserver(self, forKeyPath: #keyPath(UIImageView.image))
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
    delegate?.deleteButtonAction(in: self)
  }
  
  @objc func  photoDoubleTapAction() {
    if let image = photoImageView.image  {
      delegate?.photoDoubleTapAction(photoImage: image)
    }else {
      return
    }
  }
}
