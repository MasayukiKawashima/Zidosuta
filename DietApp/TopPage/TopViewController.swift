//
//  TopViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/23.
//

import UIKit

class TopViewController: UIViewController {
  var topView = TopView()
  //回転を許可するかどうかを決める
  //デバイスの向きが変更されたときに呼び出される
  override var shouldAutorotate: Bool {
    UIDevice.current.setValue(1, forKey: "orientation")
    return false
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    
    return .portrait
  }
  
  var tabBarHeight: CGFloat {
    return tabBarController?.tabBar.frame.size.height ?? 49.0
  }
  
  var navigationBarHeight: CGFloat {
    return topView.navigationBar.frame.size.height
  }
  
  var statusBarHeight: CGFloat {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let statusBarFrame = windowScene.statusBarManager?.statusBarFrame {
      return statusBarFrame.height
    }
    return 0
  }
  //各セルの高さの定義
  var weightTableViewCellHeight:CGFloat = 70.0
  var memoTableViewCellHeight:CGFloat = 47.0
  var photoTableViewCellHeight: CGFloat {
    return view.frame.height - tabBarHeight - navigationBarHeight - statusBarHeight - weightTableViewCellHeight - memoTableViewCellHeight - adTableViewCellHeight
  }
  var adTableViewCellHeight:CGFloat = 53.0
  
  //セル周り設定用の列挙体
  enum TopPageCell: Int {
    case weightTableViewCell = 0
    case memoTableViewCell
    case photoTableViewCell
    case adTableViewCell
  }
  //pagingに使うプロパティ
  var pageIndex: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    topView.navigationBar.delegate = self
    topView.tableView.delegate = self
    topView.tableView.dataSource = self
    //セルのインスタンスからのデリゲート設定
//    if let weightCell = topView.tableView.cellForRow(at: IndexPath(row: TopPageCell.weightTableViewCell.rawValue, section: 0)) as? WeightTableViewCell {
//      weightCell.weightTextField.delegate = self
//    }
    //tableViewでタップ認識させるための設定
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(dismissKeyboard))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
    
    //スクロールできないようにする
    topView.tableView.isScrollEnabled = false
    //tableViewCellの高さの自動設定
    topView.tableView.rowHeight = UITableView.automaticDimension
    //セル間の区切り線を非表示
    topView.tableView.separatorStyle = .none
    
    navigationBarTitleSetting()
  }

  override func loadView() {
    super.loadView()
    view = topView
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

//navigationBarの設定
extension TopViewController: UINavigationBarDelegate {
  //5.24NBのタイトルを仮配置した。各タイトルの設定（テキスト表示のアルゴリズム、AutoLayout等）後日検討
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
  
  //NavigationBarがステータスバーを覆うように表示
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

//TableViewの設定
extension TopViewController: UITableViewDelegate,UITableViewDataSource {
  //TableViewのセクション内のセルの数（5.28時点で１セクション、４セル）
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  //各セルを内容を設定し表示
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = TopPageCell(rawValue: indexPath.row)
    
    switch (cell)! {
    case .weightTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: "WeightTableViewCell", for: indexPath) as! WeightTableViewCell
      //セルの選択時のハイライトを非表示にする
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      return cell
      
    case .memoTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell", for: indexPath) as! MemoTableViewCell
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      return cell
      
    case .photoTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as! PhotoTableViewCell
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      return cell
    
    case .adTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: "AdTableViewCell", for: indexPath) as! AdTableViewCell
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      return cell
    }
  }
  //各セルの高さの推定値を設定
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    let cell = TopPageCell(rawValue: indexPath.row)
    
    switch (cell)! {
    case .weightTableViewCell:
      return weightTableViewCellHeight
      
    case .memoTableViewCell:
      return memoTableViewCellHeight
      
    case .photoTableViewCell:
      return photoTableViewCellHeight
      
    case .adTableViewCell:
      return adTableViewCellHeight
    }
  }
  //セルの高さの設定
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cell = TopPageCell(rawValue: indexPath.row)
    
    switch (cell)! {
    case .weightTableViewCell:
      return weightTableViewCellHeight
      
    case .memoTableViewCell:
      return memoTableViewCellHeight
      
    case .photoTableViewCell:
      return photoTableViewCellHeight
      
    case .adTableViewCell:
      return adTableViewCellHeight
    }
  }
}
//UITextField周りの処理
//エンターを押したらキーボードを閉じる処理
extension TopViewController {
  //キーボード以外の領域をタッチしたらキーボードを閉じる処理
  @objc public func dismissKeyboard() {
    view.endEditing(true)
  }
}

