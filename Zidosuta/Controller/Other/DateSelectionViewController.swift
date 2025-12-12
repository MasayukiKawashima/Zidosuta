//
//  DateSelectionViewController.swift
//  Zidosuta
//
//  Created by 川島真之 on 2025/12/08.
//

import UIKit

class DateSelectionViewController: UIViewController {

  // MARK: - Properties

  private var dateSeletionView = DateSelectionView()

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    .portrait
  }

  private var selectedYear: Int?
  private var selectedMonth: Int?
  private var selectedDay: Int?
  private var selectedDate = Date()

  private var selectedDateDisplayTableViewCellHeight: CGFloat = 90.0
  private var dateEditTableViewCellHeight: CGFloat = 200.0
  private var confirmTableViewCelllHeight: CGFloat = 60.0

  // MARK: - Enums

  enum DateSelectionPageCell: Int {
    case selectedDateDisplayTableViewCell = 0
    case dateEditTableViewCellHeight
    case confirmTableViewCelllHeight

     var values: (section: Int, row: Int) {
      switch self {
      case .selectedDateDisplayTableViewCell:
        return (section: 0, row: 0)
      case .dateEditTableViewCellHeight:
        return (section: 0, row: 1)
      case .confirmTableViewCelllHeight:
        return (section: 1, row: 0)
      }
    }
  }

  // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

      dateSeletionView.tableView.delegate = self
      dateSeletionView.tableView.dataSource = self
      dateSeletionView.tableView.isScrollEnabled = false
      dateSeletionView.tableView.rowHeight = UITableView.automaticDimension

      // NavigtionBarの戻るボタンの色を変更
      self.navigationController?.navigationBar.tintColor = UIColor.white

        // Do any additional setup after loading the view.
    }

  override func loadView() {

    view = dateSeletionView
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

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DateSelectionViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {

    return 2
  }

  // 12.8ひとまずTableViewを表示させる
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    switch section {
    case 0:
      return 2  // 1つ目のセクションには2つのセル
    case 1:
      return 1  // 2つ目のセクションには1つのセル
    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = DateSelectionPageCell(rawValue: indexPath.row)

    switch indexPath.section {

    case 0:
      if cell == .selectedDateDisplayTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedDateDisplayTableViewCell", for: indexPath) as! SelectedDateDisplayTableViewCell

        let defaultDate = Date()
        let combinedString = defaultDate.convertDateToSelectedDateString()
        cell.dateLabel.text = combinedString

        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateEditTableViewCell", for: indexPath) as! DateEditTableViewCell

        cell.datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
      }
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmTableViewCell", for: indexPath) as! ConfirmTableViewCell
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      return cell

    default:
      return UITableViewCell()
    }
  }

  // ピッカーで日付が選択されるたびに呼ばれるメソッド
  @objc private func dateChanged(_ sender: UIDatePicker) {

    let cellRow = DateSelectionPageCell.selectedDateDisplayTableViewCell.values.row
    let cellSection = DateSelectionPageCell.selectedDateDisplayTableViewCell.values.section

    guard let selectedDateDisplayTableViewCell = dateSeletionView.tableView.cellForRow(at: IndexPath(row: cellRow, section: cellSection)) as? SelectedDateDisplayTableViewCell else { return }

    selectedDate = sender.date
    let combinedString = selectedDate.convertDateToSelectedDateString()
    selectedDateDisplayTableViewCell.dateLabel.text = combinedString
  }

  // 一つ目のセクションの下にスペースを作るためにフッターViewを作成
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

    let footerView = UIView()
    footerView.backgroundColor = .systemGray6
    return footerView
  }

  // 1つ目のセクションの後にスペースを入れる
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

    if section == 0 {
      return 50
    }
    return 0
  }

  // 各セルの高さ設定
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    let cell = DateSelectionPageCell(rawValue: indexPath.row)
    switch indexPath.section {
    case 0:
      if cell == .selectedDateDisplayTableViewCell {
        return selectedDateDisplayTableViewCellHeight
      } else {
        return dateEditTableViewCellHeight
      }
    case 1:
      return confirmTableViewCelllHeight
    default:
      return 0
    }
  }
}
