//
//  TopPageViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/23.
//

import UIKit

class TopPageViewController: UIPageViewController {
 
  var controllers: [UIViewController] = []
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

      self.initTopPageViewContoller()
        // Do any additional setup after loading the view.
      
      navigationBarTitleSetting()
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
    return pasingModel.instantiate(Identifier: .topVC, direction: .previous)
  }
  //左スワイプ（右から左にスワイプ）進む
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    return pasingModel.instantiate(Identifier: .topVC, direction: .next)
  }
}
//navigationBarの設定
extension TopPageViewController {
  //titileの設定
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
    self.navigationItem.titleView = customTitleView
  }
  
  //BarButtonの設定
  //6.20ボタン押下時の処理は保留
  func navigationBarButtonSetting() {
    let nextBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.right"), style: .done, target: self, action: #selector(buttonPaging(_:)))
    nextBarButtonItem.tag = 1
    let previousBarButtomItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(buttonPaging(_:)))
    previousBarButtomItem.tag = 2
    
    self.navigationItem.rightBarButtonItem = nextBarButtonItem
    self.navigationItem.leftBarButtonItem = previousBarButtomItem
  }
  
  @objc func buttonPaging(_ sender: UIBarButtonItem) {
    let VC = storyboard?.instantiateViewController(withIdentifier: "TopVC") as! TopViewController
    if sender.tag == 1 {
      setViewControllers([VC], direction: .forward, animated: true)
    }
    if sender.tag == 2 {
      setViewControllers([VC], direction: .reverse, animated: true)
    }
  }
}
