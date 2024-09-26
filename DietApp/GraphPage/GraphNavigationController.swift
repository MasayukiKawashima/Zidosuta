//
//  GraphNavigationController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/06/20.
//

import UIKit

class GraphNavigationController: UINavigationController {
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .landscapeLeft
  }
  
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    return .landscapeLeft
  }
  //画面回転
  private func rotate() {
    if #available(iOS 16.0, *) {
      guard let windowScene = view.window?.windowScene else {
        return
      }
      windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeLeft))
      setNeedsUpdateOfSupportedInterfaceOrientations()
    } else {
      UIDevice.current.setValue(3, forKey: "orientation")
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  override func viewWillLayoutSubviews() {
    rotate()
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
