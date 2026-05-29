//
//  WeightTableViewCell.swift
//  Zidosuta
//
//  Created by 川島真之 on 2023/05/27.
//

import UIKit


// MARK: - WeightTableViewCellDelegate

@MainActor
protocol WeightTableViewCellDelegate: AnyObject {

  func weightTableViewCellDidRequestKeyboardDismiss(_ cell: WeightTableViewCell)
}


// MARK: - SetWeightTextFieldUnderLine

extension UITextField {

  func setWeightTextFieldUnderLine() {

    let underline = UIView()
    // heightにはアンダーラインの高さを入れる
    underline.frame = CGRect(x: 0, y: frame.height + 7, width: frame.width, height: 2.0)
    // 枠線の色
    underline.backgroundColor = UIColor.yellowishRed
    addSubview(underline)
    // 枠線を最前面に
    bringSubviewToFront(underline)
  }
}


// MARK: - WeightTableViewCell

class WeightTableViewCell: UITableViewCell {


  // MARK: - Properties

  @IBOutlet weak var weightTextField: UITextField! {
    didSet {
      weightTextField.accessibilityIdentifier = "weightTextField"
    }
  }
  @IBOutlet weak var kgLabel: UILabel!

  var delegate: WeightTableViewCellDelegate?


  // MARK: - LifeCycle

  override func awakeFromNib() {

    super.awakeFromNib()
    // Initialization code

    MainActor.assumeIsolated {

      backgroundColor = .oysterWhite
      // キーボードタイプ設定
      weightTextField.keyboardType = .decimalPad

      weightTextField.autocorrectionType = .no

      weightTextField.backgroundColor = .customLightGray

      if #available(iOS 26.0, *) {
        weightTextField.cornerConfiguration = .corners(radius: 8)
      } else {
        weightTextField.layer.cornerRadius = 8
      }
      // 2024.11.15
      // 文字列の長さによって１文字あたりのサイズを調整するかどうか
      // falseなので調整をしない
      // trueにすると、ペーストで値を入力した際にプレスホルダーのフォントサイズが変わってしまう
      // 原因は不明だが、このプロパティをfalseにしたら上記の現象が発生しなくなり、現状は体重テキストフィールドではサイズの調整は必要ないのでこの設定にしておく
      // メモテキストフィールドでは上記の現象はいまのところ発生していないのでtrueにする
      weightTextField.adjustsFontSizeToFitWidth = false

      let placeholderText = PlaceholderString.weightTextField
      let attributes: [NSAttributedString.Key: Any] = [
          .font: UIFont.systemFont(ofSize: 14),
          .foregroundColor: UIColor.customLightGray2
      ]
      weightTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)

      weightTextField.layer.borderWidth = 0.4
      weightTextField.layer.borderColor = UIColor.systemGray3.cgColor

      setUpCloseButton()
    }
  }

  override func setSelected(_ selected: Bool, animated: Bool) {

    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }

}


// MARK: - SetUpCloseButton

// キーボード上部の閉じるボタンを作成
extension WeightTableViewCell {

  private func setUpCloseButton() {

    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    // セル自身をターゲットとして、内部メソッド経由でデリゲートを呼び出す
    //    let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleCloseButtonTap))

    let closeButton = UIBarButtonItem(title: ToolBarString.closeButtonTitle, style: .plain, target: self, action: #selector(handleCloseButtonTap))

    toolBar.items = [spacer, closeButton]
    weightTextField.inputAccessoryView = toolBar
  }

  @objc private func handleCloseButtonTap() {

    delegate?.weightTableViewCellDidRequestKeyboardDismiss(self)
  }
}
