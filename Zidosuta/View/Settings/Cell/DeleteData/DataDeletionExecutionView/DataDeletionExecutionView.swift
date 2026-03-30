//
//  DataDeletionExecutionView.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/12/13.
//

import UIKit

class DataDeletionExecutionView: UIView, NibLoadable {


  // MARK: - Properties

  private let cellIdentifiers = ["DeleteAllDataTableViewCell"]

  @IBOutlet weak var tableView: UITableView! {
    didSet {
      setUpTableView()
    }
  }


  // MARK: - LifeCycle

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

    tableView.separatorStyle = .none
    tableView.backgroundColor = .systemGray6
    tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
  }
}
