//
//  TermsOfUseTableViewCell.swift
//  DietApp
//
//  Created by 川島真之 on 2024/12/17.
//

import UIKit

class TermsOfUseTableViewCell: UITableViewCell {

  @IBOutlet weak var shadowLayerView: UIView!
  @IBOutlet weak var mainBackgroundView: UIView!
  @IBOutlet weak var termsOfUseLabel: UILabel!
  @IBOutlet weak var transitionButton: UIButton! {
    didSet {
      transitionButton.tintColor = .YellowishRed
    }
  }
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    contentView.backgroundColor = .systemGray6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
