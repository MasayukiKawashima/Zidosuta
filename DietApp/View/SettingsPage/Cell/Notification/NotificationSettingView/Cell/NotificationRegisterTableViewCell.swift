//
//  NotificationRegisterTableViewCell.swift
//  DietApp
//
//  Created by 川島真之 on 2024/12/05.
//

import UIKit
protocol NotificationRegisterTableViewCellDelegate {
  func registerButtonAction()
}

class NotificationRegisterTableViewCell: UITableViewCell {

  @IBOutlet weak var shadowLayerView: UIView!
  @IBOutlet weak var registerButton: UIButton! {
    didSet {
      registerButton.layer.cornerRadius = 8
      registerButton.layer.masksToBounds = true
      registerButton.backgroundColor = .YellowishRed
      registerButton.setTitleColor(.white, for: .normal)
    }
  }
  
  var delegate: NotificationRegisterTableViewCellDelegate?
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    contentView.backgroundColor = .systemGray6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  @IBAction func registerButtonAction(_ sender: Any) {
    delegate?.registerButtonAction()
  }
  
}
