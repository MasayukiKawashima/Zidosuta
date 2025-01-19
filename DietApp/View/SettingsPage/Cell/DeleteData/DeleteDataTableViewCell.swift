//
//  DeleteDataTableViewCell.swift
//  DietApp
//
//  Created by 川島真之 on 2024/12/13.
//

import UIKit


// MARK: - DeleteDataTableViewCellDelegate

protocol DeleteDataTableViewCellDelegate {
  func transitionButtonAction()
}


// MARK: - DeleteDataTableViewCell

class DeleteDataTableViewCell: UITableViewCell {
  
  
  // MARK: - Properties
  
  @IBOutlet weak var shadowLayerView: UIView!
  @IBOutlet weak var mainBackgroundView: UIView!
  
  @IBOutlet weak var transitionButton: UIButton! {
    didSet {
      transitionButton.tintColor = .YellowishRed
    }
  }
  
  var delegate: DeleteDataTableViewCellDelegate?
  
  
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
    
    delegate?.transitionButtonAction()
  }
}

