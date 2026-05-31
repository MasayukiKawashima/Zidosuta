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

      //　テキストフィールドのボーダーのレイアウト
      weightTextField.layer.borderWidth = 1.5
      weightTextField.layer.borderColor = UIColor.customLightGray3.cgColor
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

    var toolbarHeight: CGFloat {
      if #available(iOS 26, *) {
        return 48
      } else {
        return 44
      }
    }

    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: toolbarHeight))

    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

    let button = UIButton(type: .custom)
    var config = UIButton.Configuration.plain()
    config.title = ToolBarString.closeButtonTitle
    config.baseForegroundColor = .black
    config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
    button.configuration = config

    if #available(iOS 26, *) {
        button.cornerConfiguration = .corners(radius: 20)
        button.configuration?.background.backgroundColor = .customLightGray3
    } else {
        button.layer.cornerRadius = 20
        button.configuration?.background.backgroundColor = .clear
    }
    button.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)
    button.sizeToFit()

    let closeButton = UIBarButtonItem(customView: button)
    // 念の為リキッドグラス効果をオフにする
    if #available(iOS 26, *) {
      closeButton.hidesSharedBackground = true
    }

    toolBar.items = [spacer, closeButton]
    weightTextField.inputAccessoryView = toolBar
  }

  @objc private func handleCloseButtonTap() {

    delegate?.weightTableViewCellDidRequestKeyboardDismiss(self)
  }
}
