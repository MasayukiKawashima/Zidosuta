//
//  NotificationSettingViewController.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/12/04.
//

import UIKit

class NotificationSettingViewController: UIViewController {
  
  
  // MARK: - Properties
  
  private var notificationSettingView = NotificationSettingView()
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    .portrait
  }
  //選択された時間を保持
  private var selectedHour: Int?
  private var selectedMinute: Int?
  private var selectedDate: Date = Settings.shared.notification?.notificationTime ?? Date()
  
  private var notificationTimeDisplayTableViewCellHeight:CGFloat  = 90.0
  private var notificationTimeEditTableViewCellHeight:CGFloat  = 200.0
  private var notificationRegisterTableViewCellHeight:CGFloat = 60.0
  
  var transitionSource: TransitionSource = .uiKit // デフォルトはUIKit
  
  var dismissCallback: (() -> Void)?
  
  
  // MARK: - Enums
  
  enum NotificationSettingPageCell:Int {
    case notificationTimeDisplayTableViewCell = 0
    case notificationTimeEditTableViewCell
    case notificationRegisterTableViewCell
    
     var values: (section: Int , row: Int) {
      switch self {
      case .notificationTimeDisplayTableViewCell:
        return (section: 0, row: 0)
      case .notificationTimeEditTableViewCell:
        return (section: 0, row: 1)
      case .notificationRegisterTableViewCell:
        return (section: 1, row: 0)
      }
    }
  }
  
  enum TransitionSource {
    case swiftUI
    case uiKit
  }
  
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    notificationSettingView.tableView.delegate = self
    notificationSettingView.tableView.dataSource = self
    notificationSettingView.tableView.isScrollEnabled = false
    notificationSettingView.tableView.rowHeight = UITableView.automaticDimension
    // Do any additional setup after loading the view.
  }
  
  override func loadView() {
    
    view = notificationSettingView
  }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension NotificationSettingViewController :UITableViewDelegate, UITableViewDataSource {
  
  //セクションの数を設定
  //登録ボタンの上にスペースを作るためにセクションを二つにする
  func numberOfSections(in tableView: UITableView) -> Int {
    
    return 2
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
    
    let cell = NotificationSettingPageCell(rawValue: indexPath.row)
    //セクションごとに分岐
    switch indexPath.section {
    case 0:
      if cell == .notificationTimeDisplayTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTimeDisplayTableViewCell", for: indexPath) as! NotificationTimeDisplayTableViewCell
        
        let setDate = Settings.shared.notification?.notificationTime
        let combinedString = setDate?.convertDateToNotificationTimeString()
        cell.timeLabel.text = combinedString
        //セルの選択時のハイライトを非表示にする
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTimeEditTableViewCell", for: indexPath) as! NotificationTimeEditTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.datePicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
        //ホイールのデフォルト値を記録されている（もしくはSettingのデフォルト値）に設定
        let setDate = Settings.shared.notification?.notificationTime
        cell.datePicker.date = setDate!
        return cell
      }
      
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationRegisterTableViewCell", for: indexPath) as! NotificationRegisterTableViewCell
      //セルの選択時のハイライトを非表示にする
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      cell.delegate = self
      return cell
    default:
      return UITableViewCell()
    }
  }
  
  //時間が選択されるたびに呼ばれる時間ラベル更新メソッド
  @objc private func timeChanged(_ sender: UIDatePicker) {
    
    let row = NotificationSettingPageCell.notificationTimeDisplayTableViewCell.values.row
    let section = NotificationSettingPageCell.notificationTimeDisplayTableViewCell.values.section
    
    guard let notificationTimeDisplayTableviewCell = notificationSettingView.tableView.cellForRow(at: IndexPath(row: row, section: section)) as? NotificationTimeDisplayTableViewCell else { return }
    //現在選択されている時間をselectedDateに代入
    selectedDate = sender.date
    //時間ラベルの更新
    let combinedString = selectedDate.convertDateToNotificationTimeString()
    notificationTimeDisplayTableviewCell.timeLabel.text = combinedString
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
    
    let cell = NotificationSettingPageCell(rawValue: indexPath.row)
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



// MARK: - NotificationRegisterTableViewCellDelegate

extension NotificationSettingViewController: NotificationRegisterTableViewCellDelegate {
  
  func registerButtonAction() {
    
    let settings = Settings.shared
    LocalNotificationManager.shared.requestAuthorization { [weak self] granted in
      guard let self = self else { return }
      
      if granted {
        settings.update { settings in
          let calendar = Calendar.current
          let hour = calendar.component(.hour, from: self.selectedDate)
          let minute = calendar.component(.minute, from: self.selectedDate)
          
          settings.notification?.notificationTime = self.selectedDate
          settings.notification?.hour = hour
          settings.notification?.minute = minute
          settings.notification?.isNotificationEnabled = true
          
          LocalNotificationManager.shared.setScheduleNotification()
          print("ローカル通知を設定")
        }
        
        // 遷移元に応じて適切な戻る処理を実行
        DispatchQueue.main.async {
          switch self.transitionSource {
          case .swiftUI:
            self.showRegistrationNotificationSucceses()
          case .uiKit:
            self.navigationController?.popViewController(animated: true)
          }
        }
      } else {
        DispatchQueue.main.async {
          self.showNotificationPermissionAlert()
        }
      }
    }
  }
  
  //オンボード画面から遷移していたときのみ表示するアラート
  private func showRegistrationNotificationSucceses() {
    
    let alert = UIAlertController(
      title: "通知を登録しました",
      message: nil,
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
      self.dismissCallback?()
    })
    present(alert, animated: true)
  }
  
  private func showNotificationPermissionAlert() {
    
    let alert = UIAlertController(
      title: "通知が許可されていません",
      message: "設定アプリから通知を有効にしてください",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}
