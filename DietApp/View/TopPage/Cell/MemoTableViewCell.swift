//
//  MemoTableViewCell.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/27.
//

import UIKit

class MemoTableViewCell: UITableViewCell {

  @IBOutlet weak var memoImageView: UIImageView!
  @IBOutlet weak var memoTextField: UITextField!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
