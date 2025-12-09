//
//  ConfirmTableViewCell.swift
//  Zidosuta
//
//  Created by 川島真之 on 2025/12/08.
//

import UIKit

class ConfirmTableViewCell: UITableViewCell {

  @IBOutlet weak var shadowLayerView: ShadowLayerView!

  @IBOutlet weak var confirmButton: UIButton! {
    didSet {
      confirmButton.layer.cornerRadius = 8
      confirmButton.layer.masksToBounds = true
      confirmButton.backgroundColor = .YellowishRed
      confirmButton.setTitleColor(.white, for: .normal)
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

  @IBAction func confirmButtonAction(_ sender: Any) {
  }
}
