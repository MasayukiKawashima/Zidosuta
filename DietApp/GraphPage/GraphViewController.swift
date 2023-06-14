//
//  GraphViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/23.
//

import UIKit
import Charts

class GraphViewController: UIViewController {
  var graphView = GraphView()
  var tabBatController: UITabBarController = TabBarController()
  
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
  
  // 画面を自動で回転させるかを決定する。
  override var shouldAutorotate: Bool {
    //画面が縦だった場合は回転させない
    if(UIDevice.current.orientation.rawValue == 1){
      return false
    }
    else{
      return true
    }
  }
  
  var safeAreaRight:CGFloat = CGFloat()
  var safeAreaLeft:CGFloat = CGFloat()
  var safeAreaBottom:CGFloat = CGFloat()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
      UIDevice.current.setValue(4, forKey: "orientation")
      //画面の向きを変更させるために呼び出す。
      print(supportedInterfaceOrientations)
      
      navigationBarTitleSetting()
      
      graphSetting()
    }
  
  override func loadView() {
    super.loadView()
    view = graphView
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    //safeAreaの取得
    if #available(iOS 11.0, *) {
     
      safeAreaLeft = self.view.safeAreaInsets.left
      safeAreaRight = self.view.safeAreaInsets.right
      safeAreaBottom = self.view.safeAreaInsets.bottom
    }
    graphViewAutoLayoutSetting()
  }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
//navigaitonBarの設定
extension GraphViewController {
  func navigationBarTitleSetting (){
    
    let yearText = "2023"
    let dateText = "5.1 - 5.31"
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

    //AutoLayoutを使用するための設定
    yearTextLabel.translatesAutoresizingMaskIntoConstraints = false
    dateTextLabel.translatesAutoresizingMaskIntoConstraints = false
  
    // カスタムビューにUILabelを追加
    customTitleView.addSubview(yearTextLabel)
    customTitleView.addSubview(dateTextLabel)

    //AutoLayoutの設定
    NSLayoutConstraint.activate([
      //yearTextLabelのY座標の中心はcustomTitleViewのY座標の中心に等しいという制約→つまりNavigationBarのY座標の中心
      yearTextLabel.centerYAnchor.constraint(equalTo: customTitleView.centerYAnchor),
      //この制約については後日確認
      yearTextLabel.leadingAnchor.constraint(equalTo: yearTextLabel.leadingAnchor),
      //yearTextLabelの右端は隣のラベルであるdateTextLabelの左端より−１2ポイント（１2ポイント左）になるように制約する
      yearTextLabel.trailingAnchor.constraint(equalTo: dateTextLabel.leadingAnchor, constant:  -12.0),

      dateTextLabel.centerYAnchor.constraint(equalTo: customTitleView.centerYAnchor),
      dateTextLabel.trailingAnchor.constraint(equalTo: dateTextLabel.trailingAnchor),
      dateTextLabel.centerXAnchor.constraint(equalTo: customTitleView.centerXAnchor),

    ])
    //カスタムビューをNavigationBarに追加
    graphView.navigationItem.titleView = customTitleView
  }
}

//graphViewのオートレイアウト設定
extension GraphViewController {
  func graphViewAutoLayoutSetting() {
    let graphView = graphView.graphAreaView
    graphView?.translatesAutoresizingMaskIntoConstraints = false
    //余白
    let bottomMargin = safeAreaBottom + 10.0
    let leftMargin = safeAreaLeft + 5.0
    let rightMargin = safeAreaRight + 5.0
    
    NSLayoutConstraint.activate([
    graphView!.topAnchor.constraint(equalTo: self.view.topAnchor, constant:self.tabBatController.tabBar.frame.size.height),
    graphView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: leftMargin),
    graphView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -rightMargin),
    graphView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -bottomMargin),
    ])
    
  }
}

//グラフの設定
extension GraphViewController {
  func graphSetting() {
    
    let  sampleEntries = [
      ChartDataEntry(x: 1, y: 15),
      ChartDataEntry(x: 2, y: 20),
      ChartDataEntry(x: 3, y: 15),
      ChartDataEntry(x: 4, y: 25),
      ChartDataEntry(x: 5, y: 18),
      ChartDataEntry(x: 6, y: 22),
      ChartDataEntry(x: 7, y: 27),
      ChartDataEntry(x: 8, y: 32),
      ChartDataEntry(x: 9, y: 26),
      ChartDataEntry(x: 10, y: 28),
      ChartDataEntry(x: 11, y: 30),
      ChartDataEntry(x: 12, y: 27),
      ChartDataEntry(x: 13, y: 24),
      ChartDataEntry(x: 14, y: 31),
      ChartDataEntry(x: 15, y: 25),
  ]
    
    let dataSet = LineChartDataSet(entries: sampleEntries)
    //エントリーポイント及びエントリーラインに関する調整
    
    //エントリーポイントとグラフ線の色を作成
    let entryPointColor = UIColor(red: 72/255, green: 135/255, blue: 191/255, alpha: 1.0)
    let graphLineColor = UIColor(red: 72/255, green: 135/255, blue: 191/255, alpha: 0.5)
    //エントリーポイントを二重円ではなく、通常の円にする
    dataSet.drawCircleHoleEnabled = false
    //エントリーポイントのサイズの調整
    dataSet.circleRadius = 5.0
    //エントリーポイントの色を設定
    dataSet.circleColors = [entryPointColor]
    //グラフ線の太さの調整
    dataSet.lineWidth = 1.5
    //グラフ線の色を設定
    dataSet.setColor(graphLineColor)
    //エントリーポイントのラベルを非表示
    dataSet.drawValuesEnabled = false
    //データのセット
    let data = LineChartData(dataSet: dataSet)
    graphView.graphAreaView.data = data
    //凡例を非表示
    graphView.graphAreaView.legend.enabled = false
    
    //グラフのX軸とY軸とグリッド線に関する調整
    
    //右のY軸のメモリを非表示
    graphView.graphAreaView.rightAxis.drawLabelsEnabled = false
    //X軸のメモリの表示を下に設定
    graphView.graphAreaView.xAxis.labelPosition = .bottom
    //Y軸のグリッド線を非表示
    //※横画面の場合X軸とY軸が逆になる
    graphView.graphAreaView.xAxis.drawGridLinesEnabled = false
    //X軸のグリッド線を破線表示
    graphView.graphAreaView.leftAxis.gridLineDashLengths = [2,2]
    //X軸のグリッド線の太さ調整
    graphView.graphAreaView.leftAxis.gridLineWidth = 0.3
    //X軸のグリッド線の色を調整
    graphView.graphAreaView.leftAxis.gridColor = .gray
    //Y軸のメモリのラベルの太さを調整
    graphView.graphAreaView.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
    //Y軸のメモリのラベルの色を調整
    graphView.graphAreaView.leftAxis.labelTextColor = .gray
    //右側からのグリッド線を非表示
    //※chartsのY軸のグリッド線はデフォルトでは、右からと左からの二重の線となっているため、どちらかの線を非表示にしないと破線にならない
    graphView.graphAreaView.rightAxis.drawGridLinesEnabled = false
    //Y軸の左右の軸線を非表示
    graphView.graphAreaView.leftAxis.drawAxisLineEnabled = false
    graphView.graphAreaView.rightAxis.drawAxisLineEnabled = false
    //X軸のメモリラベルの文字の太さを調整
    graphView.graphAreaView.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
    //X軸のメモリラベルの文字の色を調整
    graphView.graphAreaView.xAxis.labelTextColor = .gray
    //X軸のラベルの数を調整
    graphView.graphAreaView.xAxis.labelCount = dataSet.count
    //Y軸の軸線と最初のエントリーポイントの間の余白を設定
    graphView.graphAreaView.xAxis.spaceMin = 0.5
    graphView.graphAreaView.xAxis.spaceMax = 0.5
  }
}

