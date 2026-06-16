//
//  UpdatesDisplayViewController.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/06/14.
//

import UIKit

class UpdatesDisplayViewController: UIViewController {


  // MARK: - Properties

  let updateDisplayView = UpdatesDisplayView()


  // MARK: - LifeCycle

  override func loadView() {

    super.loadView()
    view = updateDisplayView
  }

    override func viewDidLoad() {
        super.viewDidLoad()

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
