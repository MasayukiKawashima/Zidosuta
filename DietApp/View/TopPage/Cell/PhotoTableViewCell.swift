//
//  PhotoTableViewCell.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/28.
//

import UIKit


// MARK: - PhotoTableViewCellDelegate

protocol PhotoTableViewCellDelegate {
  
  func insertButtonAction()
  func expandButtonAction(photoImage: UIImage)
  func deleteButtonAction(in cell: PhotoTableViewCell)
  func photoDoubleTapAction(photoImage: UIImage)
}


// MARK: - PhotoTableViewCell

class PhotoTableViewCell: UITableViewCell {
  
  
  // MARK: - Properties
  
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
  
  
  // MARK: - LifeCycle
  
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
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  
  // MARK: - Methods
  
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
  private func setupPhotoDoubleTapGesture() {
    
    // ダブルタップジェスチャーの作成
    let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(photoDoubleTapAction))
    // タップ回数を2回に設定
    doubleTapGesture.numberOfTapsRequired = 2
    
    // ImageViewのユーザーインタラクションを有効化
    photoImageView.isUserInteractionEnabled = true
    // ジェスチャーをImageViewに追加
    photoImageView.addGestureRecognizer(doubleTapGesture)
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
  
  @objc private func  photoDoubleTapAction() {
    
    if let image = photoImageView.image  {
      delegate?.photoDoubleTapAction(photoImage: image)
    }else {
      return
    }
  }
}
