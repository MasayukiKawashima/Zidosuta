//
//  PhotoModalView.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/10/18.
//

import UIKit


// MARK: - PhotoModalViewDelegate

protocol PhotoModalViewDelegate {

  func dismiss()
}


// MARK: - PhotoModalView

class PhotoModalView: UIView, NibLoadable {


  // MARK: - Properties

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var dismissButton: UIButton!

  private var  isDismissButtonConfigured = false

  var delegate: PhotoModalViewDelegate?


  // MARK: - Init

  override init(frame: CGRect) {

    super.init(frame: frame)
    nibInit()
  }

  required init?(coder aDecoder: NSCoder) {

    super.init(coder: aDecoder)
    nibInit()
  }


  // MARK: - LifeCycle

  override func layoutSubviews() {

    super.layoutSubviews()
    if !isDismissButtonConfigured {
      dismissButton.applyFrostedGlassEffect()
      dismissButton.setCornerRadius()
      isDismissButtonConfigured = true
    }
  }

  override  func awakeFromNib() {

    // シンボルのサイズ設定
    let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 60)
    let image = dismissButton.image(for: .normal)?.withConfiguration(symbolConfiguration)

    dismissButton.setImage(image, for: .normal)
  }


  // MARK: - Methods

  @IBAction func dismissButtonAction(_ sender: Any) {

    delegate?.dismiss()
  }
}
