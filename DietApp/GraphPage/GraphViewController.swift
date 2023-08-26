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
  
  var graphDateManager = GraphDateManager()
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    //左横画面に変更
    if(UIDevice.current.orientation.rawValue == 4){
      UIDevice.current.setValue(4, forKey: "orientation")
      return .landscapeLeft
    }
    else {
      //左横画面以外の処理
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
      
      //graphSetting()
      configureDefaultGraph(index: self.graphDateManager.index)
    }
  
  override func loadView() {
    view = graphView
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    _ = self.initViewLayout
    //グラフの更新処理
    createLineChartDate()
  }
  
  private lazy var initViewLayout : Void = {
      print(self.view.frame)
    if #available(iOS 11.0, *) {
      safeAreaLeft = self.view.safeAreaInsets.left
      safeAreaRight = self.view.safeAreaInsets.right
      safeAreaBottom = self.view.safeAreaInsets.bottom
    }
//    graphAreaViewAutoLayoutSetting()
  }()
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

//グラフの設定
extension GraphViewController {
  func configureDefaultGraph(index: Int){
    // データエントリーポイントは初期では空にしておく
    let dataEntries: [ChartDataEntry] = []
    let dataSet = LineChartDataSet(entries: dataEntries)
    //データのセット
    let data = LineChartData(dataSet: dataSet)
    graphView.graphAreaView.data = data
    //データがない場合のテキスト表示をからにする
    graphView.graphAreaView.noDataText = ""
    //グラフ内をダブルタップ及びピンチジェスチャーしたときのズームを出来ないようにする
    graphView.graphAreaView.doubleTapToZoomEnabled = false
    //マーカーの設定
    let customMarkerViewController = CustomMarkerViewController(index: index)
    let customMarkerView = CustomMarkerView()
    customMarkerView.dataSource = customMarkerViewController
//    marker.dataSource = self
    graphView.graphAreaView.marker = customMarkerView
    //凡例を非表示
    graphView.graphAreaView.legend.enabled = false
    
    let dateRangeCalculator = DateRangeCalculator()
    let results = dateRangeCalculator.calculateMonthHalfDayRange(index: index)
    //X軸の設定
    let xAxis = graphView.graphAreaView.xAxis
    //X軸のラベルの最小値を設定
    xAxis.axisMinimum = Double(results.startDay)
    //X軸のラベルの最大値を設定
    xAxis.axisMaximum = Double(results.endDay)
    //ラベルと軸線との余白を設定
    xAxis.yOffset = 5.0
   //X軸のラベルの数を決定
    let count = results.endDay - results.startDay + 1
    xAxis.setLabelCount(count, force: true)
    //X軸のメモリの表示を下に設定
    xAxis.labelPosition = .bottom
    //X軸のグリッド線を非表示
    xAxis.drawGridLinesEnabled = false
    //X軸のメモリラベルの文字の太さを調整
    xAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
    //X軸のメモリラベルの文字の色を調整
    xAxis.labelTextColor = .gray
    //X軸のラベルのフォントの種類とサイズの設定
    let xAxisLabelFont = UIFont(name: "Thonburi-Bold", size: 12)
    xAxis.labelFont = xAxisLabelFont ?? UIFont.systemFont(ofSize: 12)
    //X軸のラベルのカラーを設定
    xAxis.labelTextColor = UIColor(red: 72/255, green: 135/255, blue: 191/255, alpha: 1.0)
    //X軸の軸線のカラーを設定
    xAxis.axisLineColor = UIColor(red: 72/255, green: 135/255, blue: 191/255, alpha: 1.0)
    //X軸の軸線の太さを設定
    xAxis.axisLineWidth = CGFloat(1.0)

    //Y軸の左のラベルは表示しないが、設定は行う
    //理由は不明だが、左のY軸の設定を行わないとX軸のラベルが表示されないため
    //lineChartは左のY軸を基準としてグラフの他の要素が描画されるため、左のY軸を設定しないと予期しない挙動になる可能性がある
    let leftAxis = graphView.graphAreaView.leftAxis
    //Y軸の左ラベルの最小値を設定
    leftAxis.axisMinimum = 40.0
    //Y軸の左ラベルの最大値を設定
    leftAxis.axisMaximum = 80.0
    //左ラベルと軸線との間の余白を設定
    leftAxis.xOffset = 20.0
    //左ラベルの数を設定
    leftAxis.setLabelCount(6, force: true)
    //左側からのグリッド線を非表示
    //※chartsのY軸のグリッド線はデフォルトでは、右からと左からの二重の線となっているため、どちらかの線を非表示にしないと破線にならない
    leftAxis.drawGridLinesEnabled = false
    //左のY軸のラベルを削除
    leftAxis.drawLabelsEnabled = false
    //左の軸線を非表示
    leftAxis.drawAxisLineEnabled = false
    
    //右のY軸の設定
    let rightAxis = graphView.graphAreaView.rightAxis
    //Y軸の右ラベルの最小値を設定
    rightAxis.axisMinimum = 40.0
    //Y軸の右ラベルの最大値を設定
    rightAxis.axisMaximum = 80.0
    //右ラベルと軸線との間の余白を設定
    rightAxis.xOffset = 20.0
    //右ラベルの数を設定
    rightAxis.setLabelCount(6, force: true)
    //Y軸のグリッド線を破線表示
    rightAxis.gridLineDashLengths = [2,2]
    //X軸のグリッド線の太さ調整
    rightAxis.gridLineWidth = 0.3
    //X軸のグリッド線の色を調整
    rightAxis.gridColor = .gray
    //X軸のグリッド線の色を調整
    rightAxis.gridColor = .gray
    //Y軸のメモリのラベルの太さを調整
    rightAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
    //Y軸のメモリのラベルの色を調整
    rightAxis.labelTextColor = .gray
    //右の軸線を非表示
    rightAxis.drawAxisLineEnabled = false
    //Y軸のラベルにkgという単位を追加
    rightAxis.valueFormatter = KGAxisValueFormatter()
    //Y軸のラベルのフォントの種類とサイズの設定
    let rightAxisLabelFont =  UIFont(name: "Thonburi", size: 9)
    rightAxis.labelFont = rightAxisLabelFont ?? UIFont.systemFont(ofSize: 9)
  }
  
  //現在のページの日付の範囲のRealmオブジェクトが存在していたら、それをもとにエントリーデータを作成し描画するメソッド
  func createLineChartDate() {
    let graphContetCreator = GraphContentCreator()
    let dataEntries = graphContetCreator.createDataEntry(index: graphDateManager.index)
    if dataEntries.count != 0 {
      
      //以下の処理はモデルに切り出す
      let dataSet = LineChartDataSet(entries: dataEntries)
      
      let yValues = dataEntries.map { $0.y }
      let min = yValues.min() ?? 0
      let max = yValues.max() ?? 0

      let calculatedAxisMin = min - 5
      let calculatedAxisMax = max + 5
      
      let rightAxis = graphView.graphAreaView.rightAxis
      rightAxis.axisMinimum = calculatedAxisMin// Y軸の最小値
      rightAxis.axisMaximum = calculatedAxisMax// Y軸の最大値
      rightAxis.setLabelCount(6, force: true)
      
      //Y軸の左のラベルは表示しないが、設定は行う
      //Chartsでは左のY軸を基準としてエントリーポイントが表示される仕様
      //なので、左のY軸は使用しない（表示しない）としても設定は行わないとグラフの表示がおかしくなる
      let leftAxis = graphView.graphAreaView.leftAxis
      leftAxis.axisMinimum = calculatedAxisMin  // Y軸の最小値
      leftAxis.axisMaximum = calculatedAxisMax// Y軸の最大値
      leftAxis.setLabelCount(6, force: true)
      
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
      //エントリーポイントタップ時の十字のハイライトを非表示
//     dataSet.highlightEnabled = false
      dataSet.drawVerticalHighlightIndicatorEnabled = false
      dataSet.drawHorizontalHighlightIndicatorEnabled = false
      //データのセット
      let data = LineChartData(dataSet: dataSet)
      self.graphView.graphAreaView.data = data
    }
  }
}
