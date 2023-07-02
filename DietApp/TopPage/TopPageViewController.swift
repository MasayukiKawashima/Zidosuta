//
//  TopPageViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/23.
//

import UIKit

class TopPageViewController: UIPageViewController {
 
  var controllers: [TopViewController] = []
  var pasingModel = PagingModel()
  
  override var shouldAutorotate: Bool {
    if let vc = controllers.first {
      return vc.shouldAutorotate
    }
    return false
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if let vc = controllers.first {
      return vc.supportedInterfaceOrientations
    }
    return .portrait
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.dataSource = self
      self.delegate = self

      self.initTopPageViewContoller()
        // Do any additional setup after loading the view.
      if let currentVC = self.viewControllers?.first{
        let currentVC = currentVC as! TopViewController
        navigationBarTitleSetting(currentVC: currentVC)
      }
      
      navigationBarButtonSetting()
    }
  
  private func initTopPageViewContoller() {
    let topVC = storyboard!.instantiateViewController(withIdentifier: "TopVC") as! TopViewController
    
    self.controllers = [topVC]
    
    setViewControllers([self.controllers[0]], direction: .forward, animated: true, completion: nil)
  }
}

//PageViewContollerの内容の設定
extension TopPageViewController: UIPageViewControllerDataSource {

  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return self.controllers.count
  }
  //各スワイプ時の処理
  //右スワイプ（左から右にスワイプ）戻る
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    return pasingModel.topVCInstantiate(for: self, direction: .previous)
  }
  //左スワイプ（右から左にスワイプ）進む
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    return pasingModel.topVCInstantiate(for: self, direction: .next)
  }
}
//遷移時の処理
extension TopPageViewController: UIPageViewControllerDelegate {
  //遷移が終わった後に呼び出されるデリゲートメソッド
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    //遷移が完了したら
    if completed{
      let currentVC = pageViewController.viewControllers?.first as! TopViewController
      navigationBarTitleSetting(currentVC: currentVC)
    }
  }
}
//navigationBarの設定
extension TopPageViewController {
  //titileの設定
  func navigationBarTitleSetting (currentVC: TopViewController){
    var yearText = ""
    var dateText = ""
    var dayOfWeekText = ""
    let dateFontSize: CGFloat = 18.0
    let fontSize: CGFloat = 14.0
    
    //現在のページの年、日付、曜日のデータを取得
    let date = Date()
    let modifiedDate = Calendar.current.date(byAdding: .day, value: currentVC.index, to: date)

    // カスタムビューをインスタンス化
    let customTitleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    
    //年の表示形式の設定
    let yearFormatter = DateFormatter()
    yearFormatter.dateFormat = "yyyy"
    yearText = yearFormatter.string(from: modifiedDate!)

    let yearTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 22))
    yearTextLabel.text = yearText
    yearTextLabel.font = UIFont(name: "Thonburi", size: fontSize)
    yearTextLabel.textColor = .black
    yearTextLabel.sizeToFit()
    
    //日付の表示形式を設定
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M.d"
    dateText = dateFormatter.string(from: modifiedDate!)
    
    let dateTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 22))
    dateTextLabel.text = dateText
    dateTextLabel.font = UIFont(name: "Thonburi-Bold", size: dateFontSize)
    dateTextLabel.textColor = .black
    dateTextLabel.sizeToFit()
    
    //曜日の表示形式の設定
    let dayOfWeek = Calendar.current.component(.weekday, from: modifiedDate!)
    let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    dayOfWeekText = weekDays[dayOfWeek - 1]

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
    self.navigationItem.titleView = customTitleView
  }
  
  //BarButtonの設定
  func navigationBarButtonSetting() {
    let nextBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.right"), style: .done, target: self, action: #selector(buttonPaging(_:)))
    nextBarButtonItem.tag = 1
    let previousBarButtomItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(buttonPaging(_:)))
    previousBarButtomItem.tag = 2
    
    self.navigationItem.rightBarButtonItem = nextBarButtonItem
    self.navigationItem.leftBarButtonItem = previousBarButtomItem
  }
  //BarButton押下時の画面遷移
  @objc func buttonPaging(_ sender: UIBarButtonItem) {
    let currentVC = self.viewControllers?.first as! TopViewController
    let currentIndex = currentVC.index
    let topVC = storyboard?.instantiateViewController(withIdentifier: "TopVC") as! TopViewController
    //next
    if sender.tag == 1 {
      let nextIndex = currentIndex + 1
      topVC.index = nextIndex
      navigationBarTitleSetting(currentVC: topVC)
      setViewControllers([topVC], direction: .forward, animated: true)
    }
    //previous
    if sender.tag == 2 {
      let nextIndex = currentIndex - 1
      topVC.index = nextIndex
      navigationBarTitleSetting(currentVC: topVC)
      setViewControllers([topVC], direction: .reverse, animated: true)
    }
  }
}
