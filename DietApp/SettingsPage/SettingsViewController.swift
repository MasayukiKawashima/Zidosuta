//
//  SettingsViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/23.
//

import UIKit

class SettingsViewController: UIViewController {
  var settingsView = SettingsView()
  var receivedNotificationTimeString = ""
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    .portrait
  }
  
  var TableViewCellHeight:CGFloat = 60.0
  //cell周り設定用の列挙体
  enum SettingPageCell:Int {
    case themeColorTableViewCell = 0
    case notificationTableViewCell
  }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      settingsView.tableView.delegate = self
      settingsView.tableView.dataSource = self
      
      //セルの区切り線を左端まで伸ばす
      settingsView.tableView.separatorInset = UIEdgeInsets.zero
      //navigationBarのタイトルの設定
//      settingsView.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Thonburi-Bold", size: 20)!]
      //スクロールできないようにする
      settingsView.tableView.isScrollEnabled = false
      //セルの高さの自動設定
      settingsView.tableView.rowHeight = UITableView.automaticDimension
      
      navigationBarTittleSettings()
    }
  
  override func loadView() {
    super.loadView()
    view = settingsView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if !receivedNotificationTimeString.isEmpty {
      DispatchQueue.main.async {
        let indexPath = IndexPath(row: 1, section: 0)
        self.settingsView.tableView.reloadRows(at: [indexPath], with: .none)
      }
    }
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
//tableViewの設定
extension SettingsViewController: UITableViewDelegate,UITableViewDataSource {
  //セル数の設定
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  //各セルの内容の設定
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = SettingPageCell(rawValue: indexPath.row)
    
    switch (cell)! {
    case .themeColorTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeColorTableViewCell", for: indexPath) as! ThemeColorTableViewCell
      //セルの選択時のハイライトを非表示にする
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      return cell
      
    case .notificationTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
      
      if !self.receivedNotificationTimeString.isEmpty {
        cell.statusLabel.text = receivedNotificationTimeString
      }
      
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      cell.delegate = self
      return cell
    }
  }
  //セルの高さの推定値の設定
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return TableViewCellHeight
  }
  //セルの高さを設定
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return TableViewCellHeight
  }
}

extension SettingsViewController {
  func navigationBarTittleSettings() {
    
    let titleText = "設定"
    
    let customTitleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    
    let titleTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 22))
    titleTextLabel.text = titleText
    titleTextLabel.font = UIFont(name: "Thonburi-Bold", size: 18.0)
    titleTextLabel.textColor = .black
    titleTextLabel.sizeToFit()
    
    titleTextLabel.translatesAutoresizingMaskIntoConstraints = false
    
    customTitleView.addSubview(titleTextLabel)
    
    NSLayoutConstraint.activate([
      titleTextLabel.centerXAnchor.constraint(equalTo: customTitleView.centerXAnchor),
      titleTextLabel.centerYAnchor.constraint(equalTo: customTitleView.centerYAnchor)
    ])
    self.navigationItem.titleView = customTitleView
  }
}

extension SettingsViewController: NotificationTableViewCellDelegate {
  
  func switchAction(isOn: Bool) {
    guard let cell = settingsView.tableView.cellForRow(at: IndexPath(row:1, section: 0)) as? NotificationTableViewCell else { return }
    //スイッチをオンにしたら
    if isOn {
      let notificationSettingViewController = NotificationSettingViewController()
      notificationSettingViewController.delelgate = self
      navigationController?.pushViewController(notificationSettingViewController, animated: true)
      cell.statusLabel.textColor = .YellowishRed
      //オフにしたら
    } else {
      cell.statusLabel.text = "オフ"
      cell.statusLabel.textColor = .lightGray
    }
  }
}

extension SettingsViewController: NotificationSettingViewControllerDelegate {
  func setNotificatonTimeProperyValue(_ value: String) {
    receivedNotificationTimeString = value
  }
  
 
  
  
}
