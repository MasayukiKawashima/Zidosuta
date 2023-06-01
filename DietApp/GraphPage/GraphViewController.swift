//
//  GraphViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/23.
//

import UIKit

class GraphViewController: UIViewController {
  
  var graphView = GraphView()
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    //左横画面に変更
    if(UIDevice.current.orientation.rawValue == 4){
      UIDevice.current.setValue(4, forKey: "orientation")
      return .landscapeLeft
    }
    //左横画面以外の処理
    else {
      //最初の画面呼び出しで画面を右横画面に変更させる。
      UIDevice.current.setValue(3, forKey: "orientation")
      return .landscapeRight
    }
  }
  
  override var shouldAutorotate: Bool {
    if(UIDevice.current.orientation.rawValue == 1){
      return false
    }
    else{
      return true
    }
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      
      graphView.navigationBar.backgroundColor = UIColor.cyan
      
      UIDevice.current.setValue(4, forKey: "orientation")
      
      //画面の向きを変更させるために呼び出す。
      print(supportedInterfaceOrientations)

        // Do any additional setup after loading the view.
      navigationBarTitleSetting()
    }
  
  override func loadView() {
    super.loadView()
    view = graphView
  }
    
  func navigationBarTitleSetting (){
    let yearText = "2023"
    let dateText = "5/1 ~ 5/31"
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
    graphView.navigationItem.titleView = customTitleView
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
