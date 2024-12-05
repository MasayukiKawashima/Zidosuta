//
//  ThemeColorTableViewCell.swift
//  DietApp
//
//  Created by 川島真之 on 2023/06/09.
//

import UIKit

class ThemeColorTableViewCell: UITableViewCell {
  @IBOutlet weak var mainBackgroundView: UIView!
  
  @IBOutlet weak var shadowLayerView: UIView!
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
