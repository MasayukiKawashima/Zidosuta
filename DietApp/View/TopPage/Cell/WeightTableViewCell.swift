//
//  WeightTableViewCell.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/27.
//

import UIKit

protocol WeightTableViewCellDelegate: AnyObject {
    func weightTableViewCellDidRequestKeyboardDismiss(_ cell: WeightTableViewCell)
}

class WeightTableViewCell: UITableViewCell {
  
  @IBOutlet weak var weightTextField: UITextField!
  @IBOutlet weak var kgLabel: UILabel!
  
  var delegate: WeightTableViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    //キーボードタイプ設定
    weightTextField.keyboardType = .decimalPad
    
    weightTextField.autocorrectionType = .no
    
    let placeholderText = "体重を入力"
    let attributes = [
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
    ]
    weightTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    
    weightTextField.setUnderLine()
    setUpCloseButton()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }

}
//この設定についてはよう確認
//extension WeightTableViewCell: UITextFieldDelegate {
//  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    weightTextField.resignFirstResponder()
//    return true
//  }
//}
//キーボード上部の閉じるボタンを作成
extension WeightTableViewCell {
  func setUpCloseButton() {
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    // セル自身をターゲットとして、内部メソッド経由でデリゲートを呼び出す
    let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleCloseButtonTap))
    
    toolBar.items = [spacer, closeButton]
    weightTextField.inputAccessoryView = toolBar
  }
  @objc private func handleCloseButtonTap() {
    delegate?.weightTableViewCellDidRequestKeyboardDismiss(self)
  }
}

//拡張の内容、記述場所は後日検討
extension UITextField {
  func setUnderLine() {
    let underline = UIView()
    // heightにはアンダーラインの高さを入れる
    underline.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 2.0)
    // 枠線の色
    underline.backgroundColor = .systemGray
    addSubview(underline)
    // 枠線を最前面に
    bringSubviewToFront(underline)
  }
}
