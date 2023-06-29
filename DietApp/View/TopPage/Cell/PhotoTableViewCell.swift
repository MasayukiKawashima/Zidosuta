//
//  PhotoTableViewCell.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/28.
//

import UIKit

protocol PhotoTableViewCellDelegate {
  func insertButonAction()
}

class PhotoTableViewCell: UITableViewCell {

  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var insertButton: UIButton!
  
  @IBOutlet weak var commentLabel: UILabel!
  @IBOutlet weak var redoButton: UIButton!
  
  var delegate: PhotoTableViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    //systemImageのサイズ調整
    let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 40)
    let image = insertButton.image(for: .normal)?.withConfiguration(symbolConfiguration)
    insertButton.setImage(image, for: .normal)
    insertButton.imageView?.contentMode = .scaleAspectFit
    //ボタンのサイズ調整
    if let image = image {
      let buttonSize = CGSize(width: image.size.width + 20, height: image.size.height + 20)
      insertButton.frame = CGRect(origin: insertButton.frame.origin, size: buttonSize)
    }else{
      return
    }
  }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  @IBAction func insertButtonAction(_ sender: Any) {
    delegate?.insertButonAction()
  }
  
  @IBAction func redoButtonAction(_ sender: Any) {
    delegate?.insertButonAction()
  }
}
