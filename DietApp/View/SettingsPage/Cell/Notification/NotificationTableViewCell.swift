//
//  NotificationTableViewCell.swift
//  DietApp
//
//  Created by 川島真之 on 2023/06/09.
//

import UIKit

protocol NotificationTableViewCellDelegate {
  func switchAction()
}

class NotificationTableViewCell: UITableViewCell {

  @IBOutlet weak var mainBackgroundView: UIView!
  @IBOutlet weak var shadowLayerView: UIView!
  @IBOutlet weak var notificationSwitch: UISwitch!
  @IBOutlet weak var statusLabel: UILabel!
  
  var delegate: NotificationTableViewCellDelegate?
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    self.contentView.backgroundColor = .systemGray6
    
    notificationSwitch.onTintColor = .YellowishRed
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  @IBAction func switchAction(_ sender: Any) {
    delegate?.switchAction()
  }
}
