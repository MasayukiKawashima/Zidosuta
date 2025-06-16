//
//  AdTableViewCell.swift
//  Zidosuta
//
//  Created by 川島真之 on 2023/05/28.
//

import UIKit
import GoogleMobileAds

class AdTableViewCell: UITableViewCell {

  // MARK: - Properties

  @IBOutlet weak var bannerView: GADBannerView! {
    didSet {
      backgroundView?.backgroundColor = .OysterWhite
    }
  }

  @IBOutlet weak var placeholderView: UIView!
  @IBOutlet weak var placeholderLogo: UIImageView!

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
