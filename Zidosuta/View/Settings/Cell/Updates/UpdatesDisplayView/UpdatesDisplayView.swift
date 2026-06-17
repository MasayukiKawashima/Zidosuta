//
//  UpdatesDisplayView.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/06/16.
//

import UIKit

class UpdatesDisplayView: UIView, NibLoadable {


  // MARK: - Properties

  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableViewSetting()
    }
  }

  let cellIdentifier = "UpdatesDisplayTableViewCell"


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

  private func tableViewSetting() {

    let nib = UINib(nibName: cellIdentifier, bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: cellIdentifier)

    // 他TableViewのUI調整

    // 各セルの高さを自動調整
    // UpdatesDisplayTableViewCellのawakeFromNibでもCellのContentViewの最低の高さを60にする制約を設定している
    tableView.estimatedRowHeight = 60
    tableView.rowHeight = UITableView.automaticDimension
  }
}
