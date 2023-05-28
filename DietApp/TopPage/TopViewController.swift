//
//  TopViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/23.
//

import UIKit

class TopViewController: UIViewController {
//topViewの保持
  var topView = TopView()
  
  override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    topView.navigationBar.delegate = self
    topView.tableView.delegate = self
    topView.tableView.dataSource = self
    
    topView.tableView.rowHeight = UITableView.automaticDimension
    
    topView.navigationBar.backgroundColor = UIColor.cyan
    
    navigationBarTitleSetting()
    }
  
  override func loadView() {
    super.loadView()
    view = topView
  }
  
  //5.24NavigationBarのタイトルを仮配置した。各タイトルの設定（テキスト表示のアルゴリズム、AutoLayout等）後日検討
  //NavigationBarのタイトル設定
  func navigationBarTitleSetting (){
    let yearText = "2023"
    let dateText = "5.24"
    let dayOfWeekText = "wed"
    let dateFontSize: CGFloat = 18.0
    let fontSize: CGFloat = 14.0
    
    // カスタムビューをインスタンス化
    let customTitleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))

    // UILabelを作成してテキストを設定
    let yearTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 22))
    yearTextLabel.text = yearText
    yearTextLabel.font = UIFont(name: "Thonburi", size: fontSize)
    yearTextLabel.textColor = .black
    yearTextLabel.sizeToFit()

    let dateTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 22))
    dateTextLabel.text = dateText
    dateTextLabel.font = UIFont(name: "Thonburi-Bold", size: dateFontSize)
    dateTextLabel.textColor = .black
    dateTextLabel.sizeToFit()

    let dayOfWeekTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 22))
    dayOfWeekTextLabel.text = dayOfWeekText
    dayOfWeekTextLabel.font = UIFont(name: "Thonburi", size: fontSize)
    dayOfWeekTextLabel.textColor = .black
    dayOfWeekTextLabel.sizeToFit()

    //AutoLayoutを使用するための設定
    yearTextLabel.translatesAutoresizingMaskIntoConstraints = false
    dateTextLabel.translatesAutoresizingMaskIntoConstraints = false
    dayOfWeekTextLabel.translatesAutoresizingMaskIntoConstraints = false

    // カスタムビューにUILabelを追加
    customTitleView.addSubview(yearTextLabel)
    customTitleView.addSubview(dateTextLabel)
    customTitleView.addSubview(dayOfWeekTextLabel)

    //AutoLayoutの設定
    NSLayoutConstraint.activate([
      //yearTextLabelのY座標の中心はcustomTitleViewのY座標の中心に等しいという制約→つまりNavigationBarのY座標の中心
      yearTextLabel.centerYAnchor.constraint(equalTo: customTitleView.centerYAnchor),
      //この制約については後日確認
      yearTextLabel.leadingAnchor.constraint(equalTo: yearTextLabel.leadingAnchor),
      //yearTextLabelの右端は隣のラベルであるdateTextLabelの左端より−１０ポイント（１０ポイント左）になるように制約する
      yearTextLabel.trailingAnchor.constraint(equalTo: dateTextLabel.leadingAnchor, constant:  -12.0),

      dateTextLabel.centerYAnchor.constraint(equalTo: customTitleView.centerYAnchor),
      dateTextLabel.trailingAnchor.constraint(equalTo: dayOfWeekTextLabel.leadingAnchor, constant: -12.0),
      dateTextLabel.centerXAnchor.constraint(equalTo: customTitleView.centerXAnchor),

      dayOfWeekTextLabel.centerYAnchor.constraint(equalTo: customTitleView.centerYAnchor),
      dayOfWeekTextLabel.trailingAnchor.constraint(equalTo: dayOfWeekTextLabel.trailingAnchor)

    ])
    //カスタムビューをNavigationBarに追加
    topView.navigationItem.titleView = customTitleView
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

extension TopViewController: UINavigationBarDelegate {
  //NavigationBarがステータスバーを覆うように表示
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

extension TopViewController: UITableViewDelegate,UITableViewDataSource {
  //TableViewのセクション内のセルの数（5.28時点で１セクション、４セル）
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  //各セルを内容を設定し表示
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell()
    
    switch indexPath.row {
    case 0:
      cell = tableView.dequeueReusableCell(withIdentifier: "WeightTableViewCell", for: indexPath) as! WeightTableViewCell
      
    case 1:
      cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell", for: indexPath) as! MemoTableViewCell
      
    case 2:
      cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as! PhotoTableViewCell
    
    case 3:
      cell = tableView.dequeueReusableCell(withIdentifier: "AdTableViewCell", for: indexPath) as! AdTableViewCell
      
    default:
      print("セルの取得に失敗しました")
    }
    return cell
//    let cell = tableView.dequeueReusableCell(withIdentifier: "WeightTableViewCell", for: indexPath) as! WeightTableViewCell
//    return cell
  }
  //各セルの高さの推定値を設定
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.row {
    case 0:
      return 44.0
    case 1:
      return 44.0
    case 2:
      return 440.0
    case 3:
      return 50.0
    default:
      return 44.0
    }
  }
  
}
