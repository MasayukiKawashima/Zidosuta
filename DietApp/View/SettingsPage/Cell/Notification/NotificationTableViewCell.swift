//
//  NotificationTableViewCell.swift
//  DietApp
//
//  Created by 川島真之 on 2023/06/09.
//

import UIKit


// MARK: - NotificationTableViewCellDelegate

protocol NotificationTableViewCellDelegate {
  func switchAction(isOn: Bool)
}


// MARK: - NotificationTableViewCell

class NotificationTableViewCell: UITableViewCell {
  
  
  // MARK: - Properties
  
  @IBOutlet weak var mainBackgroundView: UIView!
  @IBOutlet weak var shadowLayerView: UIView!
  @IBOutlet weak var notificationSwitch: UISwitch!
  @IBOutlet weak var statusLabel: UILabel! {
    didSet {
      statusLabel.textColor = .YellowishRed
    }
  }
  
  var delegate: NotificationTableViewCellDelegate?
  
  
  // MARK: - LifeCycle
  
  override func awakeFromNib() {
    
    super.awakeFromNib()
    // Initialization code
    self.contentView.backgroundColor = .systemGray6
    
    notificationSwitch.onTintColor = .YellowishRed
    notificationSwitch.tintColor = .lightGray
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  
  // MARK: - Methods
  
  @IBAction func switchAction(_ sender: UISwitch) {
    
    delegate?.switchAction(isOn: sender.isOn)
  }
}
