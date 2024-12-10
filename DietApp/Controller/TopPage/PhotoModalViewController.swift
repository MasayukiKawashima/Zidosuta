//
//  PhotoModalViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2024/10/18.
//

import UIKit

class PhotoModalViewController: UIViewController {
  
  var photoModalView = PhotoModalView()
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      
      photoModalView.delegate = self
      photoModalView.scrollView.delegate = self
      setScrollView()
        // Do any additional setup after loading the view.
    }
  
  override func loadView() {
    view = photoModalView
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    centerScrollview()
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

extension PhotoModalViewController: PhotoModalViewDelegate {
  //モーダルを閉じる処理
  func dismiss() {
    dismiss(animated: true)
  }
}
//scrollViewの設定
extension PhotoModalViewController: UIScrollViewDelegate {

  func setScrollView() {
    //scrollの範囲の設定
    photoModalView.scrollView.minimumZoomScale = 1.0
    photoModalView.scrollView.maximumZoomScale = 4.0
    
    photoModalView.scrollView.isScrollEnabled = true
  }
  //スクロールの初期位置をViewControllerの中心にする設定
  func centerScrollview() {
    DispatchQueue.main.async {
      // コンテンツの中心点を計算
      let centerX = (self.photoModalView.scrollView.contentSize.width - self.photoModalView.scrollView.bounds.width) / 2
      let centerY = (self.photoModalView.scrollView.contentSize.height - self.photoModalView.scrollView.bounds.height) / 2
      
      // スクロールビューの中心にスクロール
      let centerPoint = CGPoint(x: centerX, y: centerY)
      self.photoModalView.scrollView.setContentOffset(centerPoint, animated: false)
    }
  }
  //スクロール対象の設定
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return photoModalView.photoImageView
  }

}
