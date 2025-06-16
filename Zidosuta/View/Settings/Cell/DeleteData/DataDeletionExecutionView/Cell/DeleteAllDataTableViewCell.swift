//
//  DeleteAllDataTableViewCell.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/12/13.
//

import UIKit

// MARK: - DeleteAllDataTableViewCellDelegate

protocol DeleteAllDataTableViewCellDelegate {

  func deleteButtonAction()
}

class DeleteAllDataTableViewCell: UITableViewCell {

  // MARK: - Properties

  @IBOutlet weak var shadowLayerview: UIView!
  @IBOutlet weak var mainBackgroundView: UIView! {
    didSet {
      mainBackgroundView.backgroundColor = .OysterWhite
    }
  }

  @IBOutlet weak var deleteButton: UIButton! {
    didSet {
      let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 40)
      let image = deleteButton.image(for: .normal)?.withConfiguration(symbolConfiguration)
      deleteButton.setImage(image, for: .normal)
    }
  }

  var delegate: DeleteAllDataTableViewCellDelegate?

  // MARK: - LifeCycle

  override func awakeFromNib() {

    super.awakeFromNib()
    // Initialization code
    self.contentView.backgroundColor = .systemGray6
  }

  override func setSelected(_ selected: Bool, animated: Bool) {

    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  // MARK: - Methods

  @IBAction func deleteButtonAction(_ sender: UIButton) {

    delegate?.deleteButtonAction()
  }
}
