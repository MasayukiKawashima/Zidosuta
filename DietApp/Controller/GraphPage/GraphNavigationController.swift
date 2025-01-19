//
//  GraphNavigationController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/06/20.
//

import UIKit

class GraphNavigationController: UINavigationController {
  
  
  // MARK: - Properties
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .landscapeLeft
  }
  
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    return .landscapeLeft
  }
  
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.YellowishRed
    
    self.navigationBar.standardAppearance = appearance
    self.navigationBar.scrollEdgeAppearance = appearance
    
    self.navigationController?.navigationBar.compactAppearance = appearance
  }
  
  
  // MARK: - Methods
  
  //現状必要のないメソッドだが将来の作業に備えて残しておく
  //画面回転
  private func graphViewControllersRotate() {
    
    if #available(iOS 16.0, *) {
      guard let windowScene = view.window?.windowScene else {
        return
      }
      windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeLeft))
      setNeedsUpdateOfSupportedInterfaceOrientations()
    } else {
      UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
    }
  }
}
