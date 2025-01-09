//
//  GraphViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/23.
//

import UIKit
import Charts
import RealmSwift

class GraphViewController: UIViewController {
  var graphView = GraphView()
  
  var graphDateManager = GraphDateManager()
  
  let realm = try! Realm()
  var notificationToken: NotificationToken?
  var shouldReloadDataAfterDeletion: Bool = false
  
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .landscapeLeft
  }
  
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    return .landscapeLeft
  }
  
  var safeAreaRight:CGFloat = CGFloat()
  var safeAreaLeft:CGFloat = CGFloat()
  var safeAreaBottom:CGFloat = CGFloat()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    configureDefaultGraph(index: self.graphDateManager.index)
    setupRealmObserver()
    configureGestureRecognizers()
    
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
  
  override func viewWillAppear(_ animated: Bool) {
    if shouldReloadDataAfterDeletion {
      createLineChartDate()
      self.shouldReloadDataAfterDeletion = false
    }
  }
  //graphView上での複数種類のユーザーアクションに対応するためメソッド
  private func configureGestureRecognizers() {
    guard let pageViewController = parent as? UIPageViewController else { return }
    let pageGestureRecognizers = pageViewController.gestureRecognizers
    
    // グラフのジェスチャーレコグナイザーを取得
    guard let chartGestureRecognizers = graphView.graphAreaView.gestureRecognizers else { return }
    
    // 各ジェスチャーレコグナイザーにデリゲートを設定
    for chartGesture in chartGestureRecognizers {
      chartGesture.delegate = self
      // グラフのパンジェスチャーの場合、PageViewControllerのジェスチャーと同時認識を可能にする
      if let panGesture = chartGesture as? UIPanGestureRecognizer {
        for pageGesture in pageGestureRecognizers {
          panGesture.require(toFail: pageGesture)
        }
      }
    }
  }
  
  private func setupRealmObserver() {
    let dateData = realm.objects(DateData.self)
    
    notificationToken = dateData.observe { changes in
      switch changes {
      case .update:
        if dateData.isEmpty && !self.shouldReloadDataAfterDeletion {
          self.shouldReloadDataAfterDeletion = true
        }
      case .initial:
        return
      case .error(let error):
        print("RealmObject監視でのエラー: \(error)")
      }
    }
  }
  
  private lazy var initViewLayout : Void = {
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
  func configureDefaultGraph(index: Int) {
    // データエントリーポイントは初期では空にしておく
    let dataEntries: [ChartDataEntry] = []
    let dataSet = LineChartDataSet(entries: dataEntries)
    //データのセット
    let data = LineChartData(dataSet: dataSet)
    graphView.graphAreaView.data = data
    
    // タップ感知の設定
    graphView.graphAreaView.highlightPerTapEnabled = true
    //エントリーポイントからどれだけ離れたい位置のタップまでを有効とするか
    graphView.graphAreaView.maxHighlightDistance = 40.0
    
    //データがない場合のテキスト表示をからにする
    graphView.graphAreaView.noDataText = ""
    //グラフ内をダブルタップ及びピンチジェスチャーしたときのズームを出来ないようにする
    graphView.graphAreaView.doubleTapToZoomEnabled = false
    graphView.graphAreaView.pinchZoomEnabled = false
    //グラフの表示範囲の縮小拡大操作を無効化する
    graphView.graphAreaView.setScaleEnabled(false)
    //マーカーの設定
    let customMarkerViewController = CustomMarkerViewController(index: index)
    let customMarkerView = CustomMarkerView()
    customMarkerView.dataSource = customMarkerViewController
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
    xAxis.labelTextColor = UIColor.CornflowerBlue
    //X軸の軸線のカラーを設定
    xAxis.axisLineColor = UIColor.CornflowerBlue
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
    rightAxis.setKGFormatter()
    //Y軸のラベルのフォントの種類とサイズの設定
    let rightAxisLabelFont =  UIFont(name: "Thonburi", size: 9)
    rightAxis.labelFont = rightAxisLabelFont ?? UIFont.systemFont(ofSize: 9)
  }
  
  func createLineChartDate() {
    let graphContetCreator = GraphContentCreator()
    let dataEntries = graphContetCreator.createDataEntry(index: graphDateManager.index)
    if dataEntries.count != 0 {
      print(dataEntries)
      //以下の処理はモデルに切り出す
      let dataSet = LineChartDataSet(entries: dataEntries)
      
      let yValues = dataEntries.map { $0.y }
      let min = yValues.min() ?? 0
      let max = yValues.max() ?? 0
      
      let calculatedAxisMin = min - 5
      let calculatedAxisMax = max + 5
      
      let rightAxis = graphView.graphAreaView.rightAxis
      rightAxis.axisMinimum = calculatedAxisMin // Y軸の最小値
      rightAxis.axisMaximum = calculatedAxisMax // Y軸の最大値
      rightAxis.setLabelCount(6, force: true)
      
      //Y軸の左のラベルは表示しないが、設定は行う
      //Chartsでは左のY軸を基準としてエントリーポイントが表示される仕様
      //なので、左のY軸は使用しない（表示しない）としても設定は行わないとグラフの表示がおかしくなる
      let leftAxis = graphView.graphAreaView.leftAxis
      leftAxis.axisMinimum = calculatedAxisMin  // Y軸の最小値
      leftAxis.axisMaximum = calculatedAxisMax // Y軸の最大値
      leftAxis.setLabelCount(6, force: true)
      
      let entryPointColor = UIColor.CornflowerBlue
      let graphLineColor = UIColor.CornflowerBlue.withAlphaComponent(0.5)
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
      
      dataSet.drawVerticalHighlightIndicatorEnabled = false  // 縦線を非表示
      dataSet.drawHorizontalHighlightIndicatorEnabled = false  // 横線を非表示
      
      //データのセット
      let data = LineChartData(dataSet: dataSet)
      self.graphView.graphAreaView.data = data
    } else {
      //createDataEntry()の結果、エントリーが０（該当するRealmObjectが０件だったら）
      //からのエントリーセットを作成しグラフに反映（何もエントリーポイントが表示されない）
      let blankEntries: [ChartDataEntry] = []
      let dataSet = LineChartDataSet(entries: blankEntries)
      self.graphView.graphAreaView.data = LineChartData(dataSet: dataSet)
    }
  }
}

extension GraphViewController: UIGestureRecognizerDelegate {
  //グラフView上でスワイプによる画面遷移を可能にするデリゲートメソッド
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    // グラフ上でのタップやズームなどの操作は維持しつつ、
    // PageViewControllerのスワイプジェスチャーとの同時認識を許可
    return true
  }
}
