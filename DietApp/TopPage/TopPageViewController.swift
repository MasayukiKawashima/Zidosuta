//
//  TopPageViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/23.
//

import UIKit

class TopPageViewController: UIPageViewController {
  private var controllers: [UIViewController] = []
  
  override var shouldAutorotate: Bool {
    if let VC = controllers.first {
      return VC.shouldAutorotate
    }
    return false
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if let VC = controllers.first {
      return VC.supportedInterfaceOrientations
    }
    return .portrait
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.dataSource = self
      self.initTopPageViewContoller()
        // Do any additional setup after loading the view.
    }
  
  private func initTopPageViewContoller() {
    let topVC = storyboard!.instantiateViewController(withIdentifier: "TopVC") as! TopViewController
    
    self.controllers = [topVC]
    
    setViewControllers([self.controllers[0]], direction: .forward, animated: true, completion: nil)
  }
}

//PageViewContollerの内容の設定
extension TopPageViewController: UIPageViewControllerDataSource {
  enum Direction {
    case previous
    case next
  }
  
  func instantiate(direction: Direction) -> TopViewController? {
    let currentVC = self.viewControllers![0] as! TopViewController
    let VC = storyboard?.instantiateViewController(withIdentifier: "TopVC") as! TopViewController
    
    switch direction {
    case .previous:
      let nextIndex = currentVC.pageIndex - 1
      VC.pageIndex = nextIndex
      return VC
    case .next:
      let nextIndex = currentVC.pageIndex + 1
      VC.pageIndex = nextIndex
      return VC
    }
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return self.controllers.count
  }
  
  //2023.5.23スワイプ時処理は保留
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    return instantiate(direction: .next)
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    return instantiate(direction: .previous)
  }
  
}
