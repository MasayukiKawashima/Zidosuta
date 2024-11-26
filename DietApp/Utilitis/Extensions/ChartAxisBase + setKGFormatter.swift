//
//  ChartAxisBase + setKGFormatter.swift
//  DietApp
//
//  Created by 川島真之 on 2024/11/26.
//

import Foundation
import Charts

extension AxisBase {
    /// 軸ラベルに "kg" を追加するフォーマッターを設定
    func setKGFormatter() {
        self.valueFormatter = DefaultAxisValueFormatter { value, _ in
            return "\(value)kg"
        }
    }
}
