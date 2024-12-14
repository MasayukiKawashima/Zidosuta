//
//  DataDeletionExecutionViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2024/12/13.
//

import UIKit

class DataDeletionExecutionViewController: UIViewController {
  var dataDeletionExecutionView = DataDeletionExecutionView()
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    .portrait
  }
  
  var TableViewCellHeight:CGFloat = 60.0
  
  enum DataDeletionExecutionViewCell: Int {
    case deleteAllDataTableViewCell = 0
    
    var values: (section: Int, row: Int) {
      switch self {
      case .deleteAllDataTableViewCell:
        return (section: 0, row: 0)
      }
    }
  }
  
  
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

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
}

extension DataDeletionExecutionViewController: DeleteAllDataTableViewCellDelegate {
  
  func deleteButtonAction() {
    print("aaaaaaaa")
    showConfirmationAlert()
  }
  
  func showConfirmationAlert() {
    let alert = UIAlertController(title: nil, message: "全てのデータを削除してもよろしいですか この操作は取り消せません", preferredStyle: .alert)
    
    let titleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
    let attributedTitle = NSAttributedString(string: "警告", attributes: titleAttributes)
    alert.setValue(attributedTitle, forKey: "attributedTitle")
    
    let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
    let deleteAction = UIAlertAction(title: "削除する", style: .destructive) { _ in
      self.showDeletionCompletedAlert()
    }
    
    alert.addAction(cancelAction)
    alert.addAction(deleteAction)
    self.present(alert, animated: true)
  }
  
  func showDeletionCompletedAlert() {
    let alert = UIAlertController(title: nil, message: "全てのデータが削除されました", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(okAction)
    
    self.present(alert, animated: true)
  }
  
}
