//
//  PhotoTableViewCell.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/28.
//

import UIKit

protocol PhotoTableViewCellDelegate {
  func insertButtonAction()
  func photoDoubleTapAction(photoImage: UIImage)
}

class PhotoTableViewCell: UITableViewCell {
  
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var insertButton: UIButton!
  @IBOutlet weak var commentLabel: UILabel!
  @IBOutlet weak var redoButton: UIButton!
  
  var isRedoButtonConfigured = false
  var delegate: PhotoTableViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    //systemImageのサイズ調整
    let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 40)
    let image = insertButton.image(for: .normal)?.withConfiguration(symbolConfiguration)
    insertButton.setImage(image, for: .normal)
    
    insertButton.imageView?.contentMode = .scaleAspectFit
    redoButton.isHidden = true
    
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
    super.layoutSubviews()
    if !isRedoButtonConfigured {
      setRedoButtonCornerRadius()
      applyFrostedGlassEffect()
      isRedoButtonConfigured = true
    }
  }
  //やり直しボタンを丸くするメソッド
  func setRedoButtonCornerRadius() {
    redoButton.layer.cornerRadius = redoButton.frame.size.width / 2
    redoButton.clipsToBounds = true
  }
  
  private func applyFrostedGlassEffect() {
    // ぼかし効果を持つビューを作成
    let frostedEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    frostedEffect.frame = redoButton.bounds
    frostedEffect.layer.cornerRadius = redoButton.frame.size.width / 2
    frostedEffect.clipsToBounds = true
    
    // ぼかし効果のユーザーインタラクションを無効にする
    //これをしないとボタンをタップしても反応しなくなる
    //すりガラス効果がボタンの上に乗っかるのでタップイベントがボタンに届かなくなため
    frostedEffect.isUserInteractionEnabled = false
    // UIButtonの背景をクリアに設定
    redoButton.backgroundColor = .clear
    // ぼかし効果の背景色を設定（透明度を調整）
    frostedEffect.alpha = 0.5
    // ぼかし効果をボタンの上に追加
    redoButton.insertSubview(frostedEffect, at: 0)
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
  
  @objc func  photoDoubleTapAction() {
    if let image = photoImageView.image  {
      delegate?.photoDoubleTapAction(photoImage: image)
    }else {
      return
    }
  }
}
