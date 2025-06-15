//
//  UIButton + AdjustmentOfappearance.swift
//  Zidosuta
//
//  Created by 川島真之 on 2025/01/19.
//

import Foundation
import UIKit

extension UIButton {

  // 非アクティブ状態のボタンの外観の設定
  func configureDisabledButtonAppearance() {

    self.tintColor = UIColor.systemGray.withAlphaComponent(0.3)
    self.backgroundColor = UIColor.systemGray5
  }
  // アクティブ状態のボタンの外観の設定
  func configureEnabledButtonAppearance() {

    self.tintColor = UIColor.systemBlue
    self.backgroundColor = nil
    applyFrostedGlassEffect()
  }

  /// ボタンにすりガラスエフェクトを適用する
  /// - Parameters:
  ///   - style: ブラーエフェクトのスタイル（デフォルトは.light）
  ///   - alpha: エフェクトの透明度（デフォルトは0.5）
  ///   - cornerRadius: 角丸の半径（デフォルトはボタンの幅の半分）
  func applyFrostedGlassEffect(
    _ style: UIBlurEffect.Style = .light,
    _ alpha: CGFloat = 0.8,
    _ cornerRadius: CGFloat? = nil
  ) {

    // 既存のフロストエフェクトを削除（重複防止）
    self.subviews.forEach { subview in
      if subview is UIVisualEffectView {
        subview.removeFromSuperview()
      }
    }

    // ぼかし効果を持つビューを作成
    let frostedEffect = UIVisualEffectView(effect: UIBlurEffect(style: style))
    frostedEffect.frame = self.bounds

    // 角丸の設定
    let radius = cornerRadius ?? self.frame.size.width / 2
    frostedEffect.layer.cornerRadius = radius
    frostedEffect.clipsToBounds = true

    // ぼかし効果のユーザーインタラクションを無効にする
    frostedEffect.isUserInteractionEnabled = false

    // UIButtonの背景をクリアに設定
    self.backgroundColor = .clear

    // ぼかし効果の透明度を設定
    frostedEffect.alpha = alpha

    // ぼかし効果をボタンの上に追加
    self.insertSubview(frostedEffect, at: 0)
  }

  /// すりガラスエフェクトを削除する
  func removeFrostedGlassEffect() {

    self.subviews.forEach { subview in
      if subview is UIVisualEffectView {
        subview.removeFromSuperview()
      }
    }
  }
  // ボタンを丸くする
  func setCornerRadius(_ cornerRadius: CGFloat? = nil) {

    let radius = cornerRadius ?? self.frame.size.width / 2
    self.layer.cornerRadius = radius
    self.clipsToBounds = true
  }
}
