//
//  GraphView.swift
//  Zidosuta
//
//  Created by 川島真之 on 2023/06/01.
//

import UIKit
import Charts

class GraphView: UIView, NibLoadable {


  // MARK: - Properties

  @IBOutlet weak var mainBackgroundView: UIView! {
    didSet {
      mainBackgroundView.backgroundColor = .oysterWhite
    }
  }

  @IBOutlet weak var noDataMessageView: UIView! {
    didSet {
      if #available(iOS 26, *) {
        noDataMessageView.cornerConfiguration = .corners(radius: 10)
      } else {
        noDataMessageView.layer.cornerRadius = 10
      }
    }
  }

  @IBOutlet weak var graphAreaView: LineChartView! {
    didSet {
      graphAreaView.backgroundColor = UIColor(red: 255/255, green: 253/255, blue: 242/255, alpha: 1)
    }
  }


  // MARK: - Init

  override init(frame: CGRect) {

    super.init(frame: frame)
    nibInit()
  }

  required init?(coder aDecoder: NSCoder) {

    super.init(coder: aDecoder)
    nibInit()
  }


  // MARK: - Methods

}
