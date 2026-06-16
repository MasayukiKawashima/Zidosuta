//
//  UpdatesDisplayTableViewCell.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/06/16.
//

import UIKit

class UpdatesDisplayTableViewCell: UITableViewCell {


  // MARK: - Properties

  @IBOutlet weak var versionLabel: UILabel!
  @IBOutlet weak var releaseDateLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
// MARK: - LifeCycle

  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
