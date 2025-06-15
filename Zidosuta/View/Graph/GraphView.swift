//
//  GraphView.swift
//  Zidosuta
//
//  Created by 川島真之 on 2023/06/01.
//

import UIKit
import Charts

class GraphView: UIView {

  // MARK: - Properties

  @IBOutlet weak var mainBackgroundView: UIView! {
    didSet {
      mainBackgroundView.backgroundColor = .OysterWhite
    }
  }

  @IBOutlet weak var graphAreaView: LineChartView!

  // MARK: - Init

  override init(frame: CGRect) {

    super.init(frame: frame)
    self.nibInit()
  }

  required init?(coder aDecoder: NSCoder) {

    super.init(coder: aDecoder)
    self.nibInit()
  }

  // MARK: - Methods

  private func nibInit() {

    // xibファイルのインスタンス作成
    let nib = UINib(nibName: "GraphView", bundle: nil)
    guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
    // viewのサイズを画面のサイズと一緒にする
    view.frame = self.bounds
    // サイズの自動調整
    view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

    graphAreaView.backgroundColor = UIColor(red: 255/255, green: 253/255, blue: 242/255, alpha: 1)

    self.addSubview(view)
  }
}
