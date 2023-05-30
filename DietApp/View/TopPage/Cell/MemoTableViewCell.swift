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
