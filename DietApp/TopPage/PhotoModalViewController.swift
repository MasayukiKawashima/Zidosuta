//
//  PhotoModalViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2024/10/18.
//

import UIKit

class PhotoModalViewController: UIViewController {
  
  var photoModalView = PhotoModalView()
  
  init(image: UIImage) {
    photoModalView.photoImageView.image = image
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    //scrollをオフにする
    photoModalView.scrollView.isScrollEnabled = false
    
  }
  //スクロール対象の設定
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return photoModalView.photoImageView
  }
}
