//
//  SelectedDateDisplayTableViewCell.swift
//  Zidosuta
//
//  Created by 川島真之 on 2025/12/08.
//

import UIKit

class SelectedDateDisplayTableViewCell: UITableViewCell {

  @IBOutlet weak var shadowLayerView: ShadowLayerView!
  @IBOutlet weak var mainBackgroundView: UIView!{
    didSet {
      mainBackgroundView.backgroundColor = .OysterWhite
    }
  }
  
  @IBOutlet weak var yearLabel: UILabel!
  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var dayLabel: UILabel!
  
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
