//
//  MemoTableViewCell.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/27.
//

import UIKit

class MemoTableViewCell: UITableViewCell {

  @IBOutlet weak var memoTextField: UITextField!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    
    let placeholderText = "ひとことメモ"
    let attributes = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
    ]
    memoTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }
  
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UITextField {
  func setPlaceholder(text: String, systemImageName: String) {
    let placeholderView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
    
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    imageView.image = UIImage(systemName: systemImageName)
    imageView.tintColor = .systemGray
    placeholderView.addSubview(imageView)
    
    let label = UILabel(frame: CGRect(x: 25, y: 0, width: 175, height: 44))
    label.text = text
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 14.0)
    placeholderView.addSubview(label)
    
    self.placeholder = ""
    self.leftView = placeholderView
    self.leftViewMode = .always
  }
}
