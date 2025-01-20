//
//  GraphPageViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/06/06.
//

import UIKit

class GraphPageViewController: UIPageViewController {
  
  
  // MARK: - Properties
  
  private var controllers: [UIViewController] = [GraphViewController()]
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .landscapeLeft
  }
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    return .landscapeLeft
  }
  
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    self.dataSource = self
    self.delegate = self
    
    // Do any additional setup after loading the view.
    initGraphPageViewContoller()
    
    if let currentVC = self.viewControllers?.first{
      let currentVC = currentVC as! GraphViewController
      navigationBarTitleSetting(currentVC: currentVC)
    }
    navigationBarButtonSetting()
  }
  
  
  // MARK: - Methods
  
  private func initGraphPageViewContoller() {
    
    let graphVC = storyboard!.instantiateViewController(withIdentifier: "GraphVC") as! GraphViewController
    
    self.controllers = [graphVC]
    
    setViewControllers([self.controllers[0]], direction: .forward, animated: true, completion: nil)
    
    self.dataSource = self
  }
}


// MARK: - UIPageViewControllerDataSource

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
  func instantiate(direction: TransitionDirection)-> GraphViewController {
    
    //現在のViewControllerのindexを取得
    let currentGraphVC = self.viewControllers?.first! as! GraphViewController
    //次のVCの作成
    let stroyBoard = UIStoryboard(name: "Main", bundle: nil)
    let graphVC = stroyBoard.instantiateViewController(withIdentifier: "GraphVC") as! GraphViewController
    
    switch direction {
    case .next:
      //次のページのindex番号を作成し、それをもとに次のページの日付データの更新
      let nextPageIndex = currentGraphVC.graphDateManager.index + 1
      graphVC.graphDateManager.updateDate(index: nextPageIndex)
      return graphVC
    case .previous:
      let nextPageIndex = currentGraphVC.graphDateManager.index - 1
      graphVC.graphDateManager.updateDate(index: nextPageIndex)
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


// MARK: - navigationBarViewSettings

//NavigationBarの設定
extension GraphPageViewController {
  
  private func navigationBarTitleSetting (currentVC: GraphViewController){
    
    var yearText = ""
    var dateText = ""
    let dateFontSize: CGFloat = 18.0
    let fontSize: CGFloat = 14.0
    
    // カスタムビューをインスタンス化
    let customTitleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: self.navigationController!.navigationBar.frame.size.height))
    
    //日付の設定
    //月の最初の日と最後の日をdateで取得
    let firstDateOfHalfMonth = currentVC.graphDateManager.firstDateOfHalfMonth
    let lastDateOfHalfMonth = currentVC.graphDateManager.lastDateOfHalfMonth
    //日付の表示形式の設定しStringに変換
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M.d"
    let firstDateOfHalfMonthString = dateFormatter.string(from: firstDateOfHalfMonth!)
    let lastDateOfHalfMonthString = dateFormatter.string(from: lastDateOfHalfMonth!)
    dateText = firstDateOfHalfMonthString + " - " + lastDateOfHalfMonthString
    
    let dateTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 22))
    dateTextLabel.text = dateText
    dateTextLabel.font = UIFont(name: "Thonburi-Bold", size: dateFontSize)
    dateTextLabel.textColor = .black
    dateTextLabel.sizeToFit()
    
    //年の表示形式の設定
    let yearFormatter = DateFormatter()
    yearFormatter.dateFormat = "yyyy"
    yearText = yearFormatter.string(from: firstDateOfHalfMonth!)
    
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
  private func navigationBarButtonSetting() {
    
    let nextBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.right"), style: .done, target: self, action: #selector(buttonPaging(_:)))
    nextBarButtonItem.tag = 1
    nextBarButtonItem.tintColor = .white
    let previousBarButtomItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(buttonPaging(_:)))
    previousBarButtomItem.tag = 2
    previousBarButtomItem.tintColor = .white
    
    self.navigationItem.rightBarButtonItem = nextBarButtonItem
    self.navigationItem.leftBarButtonItem = previousBarButtomItem
  }
  
  @objc private func buttonPaging(_ sender: UIBarButtonItem) {
    
    //現在のVCを作成
    let currentVC = self.viewControllers?.first as! GraphViewController
    //次のVCを作成
    let graphVC = storyboard?.instantiateViewController(withIdentifier: "GraphVC") as! GraphViewController
    
    if sender.tag == 1 {
      //次のページのindex番号を作成し、それをもとに次のページの日付データの更新
      let nextPageindex = currentVC.graphDateManager.index + 1
      graphVC.graphDateManager.updateDate(index: nextPageindex)
      navigationBarTitleSetting(currentVC: graphVC)
      setViewControllers([graphVC], direction: .forward, animated: true)
    }
    if sender.tag == 2 {
      let nextPageindex = currentVC.graphDateManager.index - 1
      graphVC.graphDateManager.updateDate(index: nextPageindex)
      navigationBarTitleSetting(currentVC: graphVC)
      setViewControllers([graphVC], direction: .reverse, animated: true)
    }
  }
}
