//
//  KGAxisValueFormatter.swift
//  DietApp
//
//  Created by 川島真之 on 2023/07/30.
//

import Foundation
import Charts

class KGAxisValueFormatter: AxisValueFormatter {
 func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\((value))kg"
    }
}
