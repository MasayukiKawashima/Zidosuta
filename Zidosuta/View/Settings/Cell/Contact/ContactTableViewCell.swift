//
//  ContactTableViewCell.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/12/23.
//

import UIKit


// MARK: - ContactTableViewCellDelegate

@MainActor
protocol ContactTableViewCellDelegate {

  func mailingButtonAction()
}


// MARK: - ContactTableViewCell

class ContactTableViewCell: UITableViewCell {


  // MARK: - Properties

  @IBOutlet weak var shadowLayerView: UIView!
  @IBOutlet weak var mainBackgroundView: UIView!
  @IBOutlet weak var contactLabel: UILabel!
  @IBOutlet weak var mailingButton: UIButton! {
    didSet {
      mailingButton.tintColor = .darkGray
    }
  }

  var delegate: ContactTableViewCellDelegate?


  // MARK: - LifeCycle

  override func awakeFromNib() {

    super.awakeFromNib()

    MainActor.assumeIsolated {
      contentView.backgroundColor = .systemGray6
    }
  }

  override func setSelected(_ selected: Bool, animated: Bool) {

    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }


  // MARK: - Methods

  @IBAction func mailingButtonAction(_ sender: UIButton) {

    delegate?.mailingButtonAction()
  }
}
