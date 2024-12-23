//
//  ContactTableViewCell.swift
//  DietApp
//
//  Created by 川島真之 on 2024/12/23.
//

import UIKit

protocol ContactTableViewCellDelegate {
  func mailingButtonAction()
}

class ContactTableViewCell: UITableViewCell {
  @IBOutlet weak var shadowLayerView: UIView!
  @IBOutlet weak var mainBackgroundView: UIView!
  @IBOutlet weak var contactLabel: UILabel!
  
  @IBOutlet weak var mailingButton: UIButton!
  
  var delegate: ContactTableViewCellDelegate?
  
  override func awakeFromNib() {
        super.awakeFromNib()
    
    contentView.backgroundColor = .systemGray6
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  @IBAction func mailingButtonAction(_ sender: UIButton) {
    delegate?.mailingButtonAction()
  }
  
  
}
