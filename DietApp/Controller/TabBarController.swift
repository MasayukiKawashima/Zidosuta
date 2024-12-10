//
//  TabBarController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/23.
//

import UIKit

extension UITabBarController {

  open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if let VC = selectedViewController {
      return VC.supportedInterfaceOrientations
    }else{
      return .portrait
    }
  }
}

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.delegate = self
      //TabBarの背景色の設定
      let appearance = UITabBarAppearance()
      appearance.backgroundColor = .white
      
      UITabBar.appearance().tintColor = UIColor.YellowishRed
      UITabBar.appearance().standardAppearance = appearance
      UITabBar.appearance().scrollEdgeAppearance = appearance
        // Do any additional setup after loading the view.
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

extension TabBarController: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    //タブをグラフページに切り替えたときのグラフ描画処理
    if let graphNavigationController = viewController as? GraphNavigationController,
       let graphPageViewController = graphNavigationController.viewControllers.first as? GraphPageViewController,
       let graphViewController = graphPageViewController.viewControllers?.first as? GraphViewController {
      graphViewController.createLineChartDate()
    }
  }
  
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    
    // 24.12.2  iOS18バグへの対処のためのダミーのタブ切り替え時のアニメーションを実装した
    //Appleがバグに対処するまでこの実装を維持する
    //フェードだがduration: 0のためアニメーションは発生しない。
    //意味のない実装だがこれをしないと、iOS18のバグでタブ切り替え直後に画面の向きが切り替え前の画面の向きで表示されてしまい、崩れたレイアウトが表示されてしまう。
    //この現象は発生後1秒程度で本来の向きに戻り、レイアウトも本来のものに戻るが一連の見た目が非常に悪く致命的なバグである。このバグはiOS17以前では発生していなかった。
    //このバグがTabBarControllerのタブ切り替え時のアニメーションに関係しているものだと考えているが、原因は特定できなかった
    //この対処はカスタムのアニメーションを実装することで、デフォルトのアニメーションを上書きするような形にすることができればバグに対処できないかと考えた結果である。
    //参考
    //https://qiita.com/tzono/items/c2770e7ad5da7b5e107e
    //https://stackoverflow.com/questions/79006130/ios-18-tab-switch-flashes-screen
    //上記の記事では画面のチラつきに関するものだが、このチラつきも当初発生しておりこれに対処しようとしたところ上記のバグにもすこし効果があった。しかし、記事内の方法だけでは完全にバグが治らず別の手段を模索していたところアニメーションの上書きというアイデアを思いついた。
    guard let fromView = selectedViewController?.view, let toView = viewController.view else {
      return false
    }
    if fromView != toView {
      UIView.transition(from: fromView, to: toView, duration: 0, options: [.transitionCrossDissolve], completion: nil)
    }
    return true
  }
}
