//
//  SettingsView.swift
//  Zidosuta
//
//  Created by 川島真之 on 2023/06/09.
//

import UIKit

class SettingsView: UIView, NibLoadable {


  // MARK: - Properties

  private let cellIdentifiers = ["NotificationTableViewCell", "DeleteDataTableViewCell", "TermsOfUseTableViewCell", "PrivacyPolicyTableViewCell", "ContactTableViewCell"]

  @IBOutlet weak var tableView: UITableView! {
    didSet {
      setUpTableView()
    }
  }

  @IBOutlet weak var copyrightView: UIView!

  @IBOutlet weak var versionLabel: UILabel! {
    didSet {
      versionLabel.textColor = .darkGray
    }
  }

  @IBOutlet weak var copyrightLabel: UILabel! {
    didSet {
      copyrightLabel.textColor = .darkGray
    }
  }


  // MARK: - LifeCycle

  override init(frame: CGRect) {

    super.init(frame: frame)
    nibInit()

    versionLabel.text = makeAppVersionText()
    copyrightLabel.text = makeCopyrightText()
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

  private func makeAppVersionText() -> String {
      let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
      return "Version \(version)"
  }

  private func makeCopyrightText() -> String {
      let year = Calendar.current.component(.year, from: Date())
      return "© \(year) Masayuki Kawashima"
  }
}
