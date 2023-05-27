//
//  WeightTableViewCell.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/27.
//

import UIKit

class WeightTableViewCell: UITableViewCell {
  
  @IBOutlet weak var weightLabel: UILabel!
  @IBOutlet weak var weightTextField: UITextField!
  @IBOutlet weak var kgLabel: UILabel!
  

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
