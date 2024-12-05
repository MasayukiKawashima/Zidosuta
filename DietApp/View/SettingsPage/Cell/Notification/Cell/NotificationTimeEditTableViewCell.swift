//
//  NotificationTimeEditTableViewCell.swift
//  DietApp
//
//  Created by 川島真之 on 2024/12/04.
//

import UIKit

class NotificationTimeEditTableViewCell: UITableViewCell {

  @IBOutlet weak var datePicker: UIDatePicker!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    datePicker.datePickerMode = .time
    if #available(iOS 13.4, *) {
      datePicker.preferredDatePickerStyle = .wheels // ホイールスタイルを使用
    }
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    datePicker.transform = CGAffineTransform(scaleX: 1, y: 1)
  }
  

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
