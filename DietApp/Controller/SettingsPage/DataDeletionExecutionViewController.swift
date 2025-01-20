//
//  DataDeletionExecutionViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2024/12/13.
//

import UIKit

class DataDeletionExecutionViewController: UIViewController {
  
  
  // MARK: - Properties
  
  var dataDeletionExecutionView = DataDeletionExecutionView()
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    .portrait
  }
  
  var TableViewCellHeight:CGFloat = 60.0
  
  
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

extension DataDeletionExecutionViewController: UITableViewDelegate,UITableViewDataSource {
  
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
      
    default :
      return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return TableViewCellHeight
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
    if section == DataDeletionExecutionViewCell.deleteAllDataTableViewCell.values.section {
      let footerView = setUpDeleteionDescriptionFooterView()
      return footerView
    }
    return nil
  }
  
  //削除の説明文を表示するフッターを作成
  private func setUpDeleteionDescriptionFooterView() -> UIView {
    
    let footerView = UIView()
    let textView = UITextView()
    
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.text = "体重、ひとことメモ、写真、通知設定が全て削除されます"
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
  //最終確認アラート
  func showConfirmationAlert() {
    
    let alert = UIAlertController(title: nil, message: "全てのデータを削除してもよろしいですか \nこの操作は取り消せません", preferredStyle: .alert)
    
    let titleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
    let attributedTitle = NSAttributedString(string: "警告", attributes: titleAttributes)
    alert.setValue(attributedTitle, forKey: "attributedTitle")
    
    let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
    let deleteAction = UIAlertAction(title: "削除する", style: .destructive) { _ in
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
  //削除成功アラート
  func showDeletionCompletedAlert() {
    
    let alert = UIAlertController(title: nil, message: "全てのデータが削除されました", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(okAction)
    
    self.present(alert, animated: true)
  }
  //削除失敗アラート
  func showDeletionFailedAlert() {
    let alert = UIAlertController(title: nil, message: "データの削除に失敗しました", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(okAction)
    
    self.present(alert, animated: true)
  }
}
