//
//  SettingsViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/23.
//

import UIKit

class SettingsViewController: UIViewController {
  var settingsView = SettingsView()
  
  var TableViewCellHeight:CGFloat = 60.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      settingsView.tableView.delegate = self
      settingsView.tableView.dataSource = self
      settingsView.navigationBar.delegate = self
      //セルの区切り線を左端まで伸ばす
      settingsView.tableView.separatorInset = UIEdgeInsets.zero
      //navigationBarのタイトルの設定
      settingsView.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Thonburi-Bold", size: 20)!]
      //スクロールできないようにする
      settingsView.tableView.isScrollEnabled = false
      //セルの高さの自動設定
      settingsView.tableView.rowHeight = UITableView.automaticDimension
    }
  
  override func loadView() {
    super.loadView()
    view = settingsView
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

extension SettingsViewController: UINavigationBarDelegate {
  //navigationBarをステータスバーを覆うように表示
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

extension SettingsViewController: UITableViewDelegate,UITableViewDataSource {
  //セル数の設定
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  //各セルの内容の設定
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell()
    
    switch indexPath.row {
    case 0:
      cell = tableView.dequeueReusableCell(withIdentifier: "ThemeColorTableViewCell", for: indexPath) as! ThemeColorTableViewCell
    case 1:
      cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
    default:
      print("セルの取得に失敗しました")
    }
    return cell
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
