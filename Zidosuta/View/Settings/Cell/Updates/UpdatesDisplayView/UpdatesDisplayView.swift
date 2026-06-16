//
//  UpdatesDisplayView.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/06/16.
//

import UIKit

class UpdatesDisplayView: UIView, NibLoadable {


  // MARK: - Properties

  @IBOutlet weak var tableView: UITableView!

  private let cellIdentifier = "Update"


    // MARK: - Init

  override init(frame: CGRect) {
    
    super.init(frame: frame)
    nibInit()
  }

  required init?(coder aDecoder: NSCoder) {

    super.init(coder: aDecoder)
    nibInit()
  }
}
