//
//  UpdatesTableViewCell.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/06/14.
//

// MARK: - UpdatesTableViewCellDelegate

@MainActor
protocol UpdatesTableViewCellDelegate {

  func UpdatesTransitionButtonAction()
}

import UIKit

class UpdatesTableViewCell: UITableViewCell {


  // MARK: - Properties

  @IBOutlet weak var shadowLayerView: ShadowLayerView!
  @IBOutlet weak var mainBackgroundView: MainBackgroundView!
  @IBOutlet weak var updatesLabel: UILabel!
  @IBOutlet weak var transitionButton: UIButton! {
    didSet {
      transitionButton.tintColor = .darkGray
    }
  }

  var delegate: UpdatesTableViewCellDelegate?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      MainActor.assumeIsolated {
        contentView.backgroundColor = .systemGray6
      }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


  // MARK: - Methods

  @IBAction func transitionButtonAction(_ sender: Any) {
    delegate?.UpdatesTransitionButtonAction()
  }
}
