//
//  MemoTableViewCell.swift
//  Zidosuta
//
//  Created by 川島真之 on 2023/05/27.
//

import UIKit


// MARK: - MemoTableViewCellDelegate

protocol MemoTableViewCellDelegate: AnyObject {
  
  func memoTableViewCellDidRequestKeyboardDismiss(_ cell: MemoTableViewCell)
}


// MARK: - MemoTableViewCell

class MemoTableViewCell: UITableViewCell {
  
  
  // MARK: - Properties
  
  @IBOutlet weak var memoTextField: UITextField!
  
  var delegate: MemoTableViewCellDelegate?
  
  
  // MARK: - LifeCycle
  
  override func awakeFromNib() {
    
    super.awakeFromNib()
    // Initialization code
    memoTextField.keyboardType = .default
    memoTextField.returnKeyType = .done
    memoTextField.delegate = self
    memoTextField.autocorrectionType = .no
    //文字列のながによる１文字あたりのサイズの自動調整
    memoTextField.adjustsFontSizeToFitWidth = true
    //最小サイズは10
    memoTextField.minimumFontSize = 10
    
    let placeholderText = "ひとことメモを入力"
    let attributes = [
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
    ]
    memoTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    
    setUpCloseButton()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}


// MARK: - UITextFieldDelegate

extension MemoTableViewCell: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    memoTextField.resignFirstResponder()
    return true
  }
}


// MARK: - SetUpCloseButton

extension MemoTableViewCell {
  
  private func setUpCloseButton() {
    
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let closeButton = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(handleCloseButtonTap))
    
    toolBar.items = [spacer, closeButton]
    memoTextField.inputAccessoryView = toolBar
  }
  
  @objc private func handleCloseButtonTap() {
    
    delegate?.memoTableViewCellDidRequestKeyboardDismiss(self)
  }
}

