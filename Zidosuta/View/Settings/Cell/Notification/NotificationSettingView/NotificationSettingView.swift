//
//  NotificationSettingView.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/12/04.
//

import UIKit

class NotificationSettingView: UIView, NibLoadable {


  // MARK: - Properties

  private let cellIdentifiers = ["NotificationTimeDisplayTableViewCell", "NotificationTimeEditTableViewCell", "NotificationRegisterTableViewCell"]

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

    tableView.backgroundColor = .systemGray6
    tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    tableView.separatorStyle = .none
  }
}
