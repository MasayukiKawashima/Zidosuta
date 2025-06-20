//
//  TermsOfUseTableViewCell.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/12/17.
//

import UIKit

// MARK: - TermsOfUseTableViewCellDelegate

protocol TermsOfUseTableViewCellDelegate {

  func TermsOfUseTransitionButtonAction()
}

// MARK: - TermsOfUseTableViewCell

class TermsOfUseTableViewCell: UITableViewCell {

  // MARK: - Properties

  @IBOutlet weak var shadowLayerView: UIView!
  @IBOutlet weak var mainBackgroundView: UIView!
  @IBOutlet weak var termsOfUseLabel: UILabel!
  @IBOutlet weak var transitionButton: UIButton! {
    didSet {
      transitionButton.tintColor = .YellowishRed
    }
  }
  var delegate: TermsOfUseTableViewCellDelegate?

  // MARK: - LifeCycle

  override func awakeFromNib() {

    super.awakeFromNib()
    // Initialization code
    contentView.backgroundColor = .systemGray6
  }

  override func setSelected(_ selected: Bool, animated: Bool) {

    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  // MARK: - Methods

  @IBAction func transitionButtonAction(_ sender: UIButton) {

    delegate?.TermsOfUseTransitionButtonAction()
  }
}
