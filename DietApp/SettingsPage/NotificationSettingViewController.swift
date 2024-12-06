//
//  NotificationSettingViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2024/12/04.
//

import UIKit

protocol NotificationSettingViewControllerDelegate {
  func setNotificatonTimeProperyValue(_ value: String)
}

class NotificationSettingViewController: UIViewController {
  
  var notificationSettingView = NotificationSettingView()
  var delelgate: NotificationSettingViewControllerDelegate?
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    .portrait
  }
  //選択された時間を保持
  var selectedHour: Int?
  var selectedMinute: Int?
  var combinedSelectedTime: String = "オフ"
  
  var notificationTimeDisplayTableViewCellHeight:CGFloat  = 90.0
  var notificationTimeEditTableViewCellHeight:CGFloat  = 200.0
  var notificationRegisterTableViewCellHeight:CGFloat = 60.0

    override func viewDidLoad() {
        super.viewDidLoad()
      
      notificationSettingView.tableView.delegate = self
      notificationSettingView.tableView.dataSource = self
      notificationSettingView.tableView.isScrollEnabled = false
      notificationSettingView.tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
  
  enum notificationSettingPageCell:Int {
    case notificationTimeDisplayTableViewCell = 0
    case notificationTimeEditTableViewCell
    case notificationRegisterTableViewCell
  }
  
  override func loadView() {
    view = notificationSettingView
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

extension NotificationSettingViewController :UITableViewDelegate, UITableViewDataSource {
  //セクションの数を設定
  //登録ボタンの上にスペースを作るためにセクションを二つにする
  func numberOfSections(in tableView: UITableView) -> Int {
    2
  }
  
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
    let cell = notificationSettingPageCell(rawValue: indexPath.row)
    //セクションごとに分岐
    switch indexPath.section {
    case 0:
      if cell == .notificationTimeDisplayTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTimeDisplayTableViewCell", for: indexPath) as! NotificationTimeDisplayTableViewCell
        //セルの選択時のハイライトを非表示にする
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTimeEditTableViewCell", for: indexPath) as! NotificationTimeEditTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.datePicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
        return cell
      }
      
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationRegisterTableViewCell", for: indexPath) as! NotificationRegisterTableViewCell
      //セルの選択時のハイライトを非表示にする
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      cell.delegate = self
      return cell
    default :
      return UITableViewCell()
    }
  }
  //時間が選択されるたびに呼ばれる時間ラベル更新メソッド
  @objc func timeChanged(_ sender: UIDatePicker) {
    guard let notificationTimeDisplayTableviewCell = notificationSettingView.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NotificationTimeDisplayTableViewCell else { return }
    
    let calendar = Calendar.current
    let date = sender.date
    
    let hour = calendar.component(.hour, from: date)
    let minute = calendar.component(.minute, from: date)
    
    if selectedHour != hour {
      selectedHour = hour
      notificationTimeDisplayTableviewCell.timeLabel.text = "\(hour) : \(selectedMinute ?? 0)"
    }
    
    if selectedMinute != minute {
      selectedMinute = minute
      notificationTimeDisplayTableviewCell.timeLabel.text = "\(selectedHour ?? 0) : \(minute)"
    }
  }
  //一つ目のセクションの下にスペースを作るためにフッターViewを作成
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
      let footerView = UIView()
    footerView.backgroundColor = .systemGray6
      return footerView
  }
  //フッターの高さ
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    if section == 0 {  // 1つ目のセクションの後にスペースを入れる
      return 50
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cell = notificationSettingPageCell(rawValue: indexPath.row)
    switch indexPath.section {
    case 0:
      if cell == .notificationTimeDisplayTableViewCell {
        return notificationTimeDisplayTableViewCellHeight
      } else {
        return notificationTimeEditTableViewCellHeight
      }
    case 1:
      return notificationRegisterTableViewCellHeight
    default:
      return 0
    }
  }
}

extension NotificationSettingViewController: NotificationRegisterTableViewCellDelegate {
  func registerButtonAction() {
    guard let hour = selectedHour else { return }
    guard let minute = selectedMinute else { return }
    
    let stringHour = String(hour)
    let stringMinute = String(minute)
  
    let combinedString = "\(stringHour) : \(stringMinute)"
    delelgate?.setNotificatonTimeProperyValue(combinedString)
    
    navigationController?.popViewController(animated: true)
  }
}
