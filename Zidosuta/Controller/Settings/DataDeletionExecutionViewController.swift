//
//  DataDeletionExecutionViewController.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/12/13.
//

import UIKit

class DataDeletionExecutionViewController: UIViewController {


  // MARK: - Properties

  private var dataDeletionExecutionView = DataDeletionExecutionView()

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    .portrait
  }

  private var TableViewCellHeight: CGFloat = 60.0


  // MARK: - Enums

  enum DataDeletionExecutionViewCell: Int {
    case deleteAllDataTableViewCell = 0

    var values: (section: Int, row: Int) {
      switch self {
      case .deleteAllDataTableViewCell:
        return (section: 0, row: 0)
      }
    }
  }


  // MARK: - LifeCycle

  override func viewDidLoad() {

    super.viewDidLoad()

    dataDeletionExecutionView.tableView.delegate = self
    dataDeletionExecutionView.tableView.dataSource = self
    dataDeletionExecutionView.tableView.isScrollEnabled = false
    dataDeletionExecutionView.tableView.rowHeight = UITableView.automaticDimension
    // Do any additional setup after loading the view.
  }

  override func loadView() {

    super.loadView()
    view = dataDeletionExecutionView
  }
}


// MARK: - UITableViewDelegate,UITableViewDataSource

extension DataDeletionExecutionViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = DataDeletionExecutionViewCell(rawValue: indexPath.row)

    switch cell {
    case .deleteAllDataTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: "DeleteAllDataTableViewCell", for: indexPath) as! DeleteAllDataTableViewCell

      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      cell.delegate = self
      return cell

    default:
      return UITableViewCell()
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    return TableViewCellHeight
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

    if section == DataDeletionExecutionViewCell.deleteAllDataTableViewCell.values.section {
      let footerView = setUpDeletionDescriptionFooterView()
      return footerView
    }
    return nil
  }

  // 削除の説明文を表示するフッターを作成 Deletion
  private func setUpDeletionDescriptionFooterView() -> UIView {

    let footerView = UIView()
    let textView = UITextView()

    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.text = DataDeletionExecutionString.DeleteAllData.footerText
    textView.textColor = .darkGray
    textView.backgroundColor = .clear
    textView.isScrollEnabled = false
    textView.isEditable = false
    textView.isSelectable = false
    textView.textContainer.lineBreakMode = .byCharWrapping
    footerView.addSubview(textView)

    NSLayoutConstraint.activate([
      textView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
      textView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
      footerView.heightAnchor.constraint(equalToConstant: 30)
    ])
    return footerView
  }
}


// MARK: - DeleteAllDataTableViewCellDelegate

extension DataDeletionExecutionViewController: DeleteAllDataTableViewCellDelegate {

  func deleteButtonAction() {

    showConfirmationAlert()
  }
  // 最終確認アラート
  private func showConfirmationAlert() {

    let alert = UIAlertController(title: nil, message: DeletionAlertString.Confirmation.message, preferredStyle: .alert)

    let titleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
    let attributedTitle = NSAttributedString(string: DeletionAlertString.Confirmation.title, attributes: titleAttributes)
    alert.setValue(attributedTitle, forKey: "attributedTitle")

    let cancelAction = UIAlertAction(title: DeletionAlertString.Confirmation.cancelActionTitle, style: .cancel)
    let deleteAction = UIAlertAction(title: DeletionAlertString.Confirmation.deleteActionTitle, style: .destructive) { _ in
      let dataDeleteManager = DataDeleteManager.shared
      let result = dataDeleteManager.deleteAllData()
      if result {
        self.showDeletionCompletedAlert()
      } else if !result {
        self.showDeletionFailedAlert()
      }

    }

    alert.addAction(cancelAction)
    alert.addAction(deleteAction)
    self.present(alert, animated: true)
  }
  // 削除成功アラート
  private func showDeletionCompletedAlert() {

    let alert = UIAlertController(title: nil, message: DeletionAlertString.DeletionCompleted.message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: DeletionAlertString.okActionTitle, style: .default)
    alert.addAction(okAction)

    self.present(alert, animated: true)
  }
  // 削除失敗アラート
  private func showDeletionFailedAlert() {
    let alert = UIAlertController(title: nil, message: DeletionAlertString.DeletionFailed.message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: DeletionAlertString.okActionTitle, style: .default)
    alert.addAction(okAction)

    self.present(alert, animated: true)
  }
}
