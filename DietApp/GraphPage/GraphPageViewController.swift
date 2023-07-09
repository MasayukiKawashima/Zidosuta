//
//  GraphPageViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/06/06.
//

import UIKit

class GraphPageViewController: UIPageViewController {
  var controllers: [UIViewController] = [GraphViewController()]
  
  override var shouldAutorotate: Bool {
    if let VC = controllers.first {
      return VC.shouldAutorotate
    }else{
      return true
    }
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if let VC = controllers.first {
      return VC.supportedInterfaceOrientations
    }else{

      return .landscapeRight
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.dataSource = self
    self.delegate = self
    
    // Do any additional setup after loading the view.
    initGraphPageViewContoller()
    
    if let currentVC = self.viewControllers?.first{
      let currentVC = currentVC as! GraphViewController
      //NavigationBarTittleの設定
      navigationBarTitleSetting(currentVC: currentVC)
      //月の前半か後半かによるindexの調整
      let indexSettingModel = IndexSettingModel()
      let index = indexSettingModel.indexSetting()
      currentVC.index = index
    }
    
    navigationBarButtonSetting()
  }
  
  private func initGraphPageViewContoller() {
    let graphVC = storyboard!.instantiateViewController(withIdentifier: "GraphVC") as! GraphViewController
    
    self.controllers = [graphVC]
    
    setViewControllers([self.controllers[0]], direction: .forward, animated: true, completion: nil)
    
    self.dataSource = self
  }
}

extension GraphPageViewController: UIPageViewControllerDataSource {
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return self.controllers.count
  }

  //右スワイプ（左から右にスワイプ）戻る
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    instantiate(direction: .previous)
  }
  
  //左スワイプ（右から左にスワイプ）進む
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    instantiate(direction: .next)
  }
  //GraphPageのページング先のインスタンス生成処理
  func instantiate(direction: Direction)-> GraphViewController {
    //現在のViewControllerのindexを取得
    let currentGraphVC = self.viewControllers?.first! as! GraphViewController
    let currentPageIndex = currentGraphVC.index
    
    let stroyBoard = UIStoryboard(name: "Main", bundle: nil)
    let graphVC = stroyBoard.instantiateViewController(withIdentifier: "GraphVC") as! GraphViewController
    
    switch direction {
    case .next:
      let nextPageIndex = currentPageIndex + 1
      graphVC.index = nextPageIndex
      return graphVC
    case .previous:
      let nextPageIndex = currentPageIndex - 1
      graphVC.index = nextPageIndex
      return graphVC
    }
  }
}
//画面遷移が終わった後に呼び出されるデリゲートメソッド
extension GraphPageViewController: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed {
      let currentVC = pageViewController.viewControllers?.first as! GraphViewController
      navigationBarTitleSetting(currentVC: currentVC)
    }
  }
}
//NavigationBarの設定
extension GraphPageViewController {
  //titleの設定
  func navigationBarTitleSetting (currentVC: GraphViewController){
    var yearText = ""
    var dateText = ""
    let dateFontSize: CGFloat = 18.0
    let fontSize: CGFloat = 14.0
    
    let date = Date()
    var modifiedDate = Date()
    let calendar = Calendar.current
    
    // カスタムビューをインスタンス化
    let customTitleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: self.navigationController!.navigationBar.frame.size.height))
    
    //日付の設定
    //まず現在の日付が月の前半の場合
    if currentVC.index % 2 == 0 {
      var firstDayString = ""
      var sixteenthDayString = ""
      
      let value = currentVC.index/2
      modifiedDate = calendar.date(byAdding: .month, value: value, to: date)!
      
      //月の最初の日と１７日目をDate型で取得
      let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: modifiedDate))!
      let sixteenthDay = calendar.date(bySetting: .day, value: 16, of: modifiedDate)!
      //日付の表示形式の設定
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "M.d"
      //上の二つのDate型の日付をStringに変換し格納
      firstDayString = dateFormatter.string(from: firstDay)
      sixteenthDayString = dateFormatter.string(from: sixteenthDay)
      //二つのStringの日付を合体させ、dateTextに格納
      dateText = firstDayString + " - " + sixteenthDayString
    }else{
      //現在の日付が月の後半だった場合
      var seventeenthDayString = ""
      var lastDayString = ""
      
      //月の更新を行う。
      let value = (currentVC.index - 1)/2
      modifiedDate = calendar.date(byAdding: .month, value: value, to: date)!
      
      let seventeenthDay = calendar.date(bySetting: .day, value: 17, of: modifiedDate)!
      //月末の取得は来月の月初を取得し、そこから１日戻すことで取得
      let add = DateComponents(month: 1, day: -1)
      let NextMonthFirstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: modifiedDate))!

      let lastDay = calendar.date(byAdding: add, to: NextMonthFirstDay)!
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "M.d"
      //上の二つのDate型の日付をStringに変換し格納
      seventeenthDayString = dateFormatter.string(from: seventeenthDay)
      lastDayString = dateFormatter.string(from: lastDay)
      
      dateText = seventeenthDayString + " - " + lastDayString
    }
    
    let dateTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 22))
    dateTextLabel.text = dateText
    dateTextLabel.font = UIFont(name: "Thonburi-Bold", size: dateFontSize)
    dateTextLabel.textColor = .black
    dateTextLabel.sizeToFit()
    
    //年の表示形式の設定
    let yearFormatter = DateFormatter()
    yearFormatter.dateFormat = "yyyy"
    yearText = yearFormatter.string(from: modifiedDate)
   
    let yearTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 22))
    yearTextLabel.text = yearText
    yearTextLabel.font = UIFont(name: "Thonburi", size: fontSize)
    yearTextLabel.textColor = .black
    yearTextLabel.sizeToFit()
    
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
    self.navigationItem.titleView = customTitleView
  }
  //barButtonの設定
  func navigationBarButtonSetting() {
    let nextBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.right"), style: .done, target: self, action: #selector(buttonPaging(_:)))
    nextBarButtonItem.tag = 1
    let previousBarButtomItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(buttonPaging(_:)))
    previousBarButtomItem.tag = 2
    
    self.navigationItem.rightBarButtonItem = nextBarButtonItem
    self.navigationItem.leftBarButtonItem = previousBarButtomItem
  }
  
  @objc func buttonPaging(_ sender: UIBarButtonItem) {
    let currentVC = self.viewControllers?.first as! GraphViewController
    let currentIndex = currentVC.index
    let graphVC = storyboard?.instantiateViewController(withIdentifier: "GraphVC") as! GraphViewController
    
    if sender.tag == 1 {
      let nextIndex = currentIndex + 1
      graphVC.index = nextIndex
      navigationBarTitleSetting(currentVC: graphVC)
      setViewControllers([graphVC], direction: .forward, animated: true)
    }
    if sender.tag == 2 {
      let nextIndex = currentIndex - 1
      graphVC.index = nextIndex
      navigationBarTitleSetting(currentVC: graphVC)
      setViewControllers([graphVC], direction: .reverse, animated: true)
    }
  }
}
