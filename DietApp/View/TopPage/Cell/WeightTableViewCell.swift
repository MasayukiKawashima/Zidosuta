//
//  WeightTableViewCell.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/27.
//

import UIKit

class WeightTableViewCell: UITableViewCell {
  
  @IBOutlet weak var weightTextField: UITextField!
  @IBOutlet weak var kgLabel: UILabel!
  

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      let placeholderText = "体重を入力"
      let attributes = [
          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
      ]
      weightTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//拡張の内容、記述場所は後日検討
extension UITextField {
  func setUnderLine() {
    borderStyle = .none
    let underline = UIView()
    // heightにはアンダーラインの高さを入れる
    underline.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 0.5)
    // 枠線の色
    underline.backgroundColor = .red
    addSubview(underline)
    // 枠線を最前面に
    bringSubviewToFront(underline)
  }
}
