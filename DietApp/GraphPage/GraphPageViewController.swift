//
//  GraphPageViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/06/06.
//

import UIKit

class GraphPageViewController: UIPageViewController {
  private var controllers: [UIViewController] = []
  
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
      return .landscapeLeft
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    initGraphPageViewContoller()
    navigationBarTitleSetting()
    navigationBarButtonSetting()
  }
  
  private func initGraphPageViewContoller() {
    let graphVC = storyboard!.instantiateViewController(withIdentifier: "GraphVC") as! GraphViewController
    
    self.controllers = [graphVC]
    
    setViewControllers([self.controllers[0]], direction: .forward, animated: true, completion: nil)
    
    self.dataSource = self
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

extension GraphPageViewController: UIPageViewControllerDataSource {
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return self.controllers.count
  }
  //スワイプ時処理は保留
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    nil
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    nil
  }
}

extension GraphPageViewController {
  //titleの設定
  func navigationBarTitleSetting (){
    let yearText = "2023"
    let dateText = "5.1 - 5.31"
    let dateFontSize: CGFloat = 18.0
    let fontSize: CGFloat = 14.0
    
    // カスタムビューをインスタンス化
    let customTitleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: self.navigationController!.navigationBar.frame.size.height))
    
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
    self.navigationItem.titleView = customTitleView
  }
  //barButtonの設定
  func navigationBarButtonSetting() {
    let nextBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.right"), style: .done, target: self, action: nil)
    let previousBarButtomItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: nil)
    
    self.navigationItem.rightBarButtonItem = nextBarButtonItem
    self.navigationItem.leftBarButtonItem = previousBarButtomItem
  }
}
