//
//  NotificationTimeDisplayTableViewCell.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/12/04.
//

import UIKit

class NotificationTimeDisplayTableViewCell: UITableViewCell {

  // MARK: - Properties

  @IBOutlet weak var shadowLayerView: UIView!
  @IBOutlet weak var mainBackgroundView: UIView! {
    didSet {
      mainBackgroundView.backgroundColor = .OysterWhite
    }
  }
  @IBOutlet weak var timeLabel: UILabel!

  // MARK: - LifeCycle

  override func awakeFromNib() {

    super.awakeFromNib()
    // Initialization code
    self.contentView.backgroundColor = .systemGray6
  }

  override func setSelected(_ selected: Bool, animated: Bool) {

    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
}
