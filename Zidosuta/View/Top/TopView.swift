//
//  TopView.swift
//  Zidosuta
//
//  Created by 川島真之 on 2023/05/26.
//

import UIKit

class TopView: UIView, NibLoadable {


  // MARK: - Properties

  private let cellIdentifiers = ["WeightTableViewCell", "MemoTableViewCell", "PhotoTableViewCell", "AdTableViewCell"]

  @IBOutlet weak var tableView: UITableView! {
    didSet {
      setUpTableView()
    }
  }


  // MARK: - Init

  override init(frame: CGRect) {

    super.init(frame: frame)
    nibInit()
  }

  required init?(coder aDecoder: NSCoder) {

    super.init(coder: aDecoder)
    nibInit()
  }


  // MARK: - Methods

  private func setUpTableView() {

    for identifier in cellIdentifiers {
      let nib = UINib(nibName: identifier, bundle: nil)
      tableView.register(nib, forCellReuseIdentifier: identifier)
    }

    tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
  }
}
