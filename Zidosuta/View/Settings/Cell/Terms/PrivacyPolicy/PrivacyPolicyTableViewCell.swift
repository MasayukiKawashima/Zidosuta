//
//  PrivacyPolicyTableViewCell.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/12/17.
//

import UIKit

protocol PrivacyPolicyTableViewCellDelegate {
  func privacyPolicyTransitionButtonAction()
}

class PrivacyPolicyTableViewCell: UITableViewCell {

  @IBOutlet weak var shadowLayerView: UIView!
  @IBOutlet weak var mainBackgroundView: UIView!
  @IBOutlet weak var privacyPolicyLabel: UILabel!
  @IBOutlet weak var transitionButton: UIButton! {
    didSet {
      transitionButton.tintColor = .YellowishRed
    }
  }
  var delegate: PrivacyPolicyTableViewCellDelegate?

  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    contentView.backgroundColor = .systemGray6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  @IBAction func transitionButtonAction(_ sender: UIButton) {
    delegate?.privacyPolicyTransitionButtonAction()
  }

}
