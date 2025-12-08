//
//  DateEditTableViewCell.swift
//  Zidosuta
//
//  Created by 川島真之 on 2025/12/08.
//

import UIKit

class DateEditTableViewCell: UITableViewCell {

  @IBOutlet weak var datePicker: UIDatePicker!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    datePicker.datePickerMode = .date
    if #available(iOS 13.4, *) {
      datePicker.preferredDatePickerStyle = .wheels
    }
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    datePicker.transform = CGAffineTransform(scaleX: 1, y: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
