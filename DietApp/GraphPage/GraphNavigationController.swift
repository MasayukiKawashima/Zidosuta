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
  
  override func viewWillLayoutSubviews() {
//    graphViewControllersRotate()
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
