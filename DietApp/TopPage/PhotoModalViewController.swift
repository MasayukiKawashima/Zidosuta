//
//  PhotoModalViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2024/10/18.
//

import UIKit

class PhotoModalViewController: UIViewController {
  
  var photoModalView = PhotoModalView()

    override func viewDidLoad() {
        super.viewDidLoad()

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
