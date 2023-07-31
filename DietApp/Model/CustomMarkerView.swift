//
//  CustomMarkerView.swift
//  DietApp
//
//  Created by 川島真之 on 2023/07/31.
//

import Foundation
import Charts
class CustomMarkerView: MarkerView {
  private var text = ""
  
  override func draw(context: CGContext, point: CGPoint) {
    let fontSize: CGFloat = 20
    let drawAttributes = [NSAttributedString.Key.font: UIFont(name: "Thonburi", size: fontSize) ?? UIFont.systemFont(ofSize: 15),
                          NSAttributedString.Key.foregroundColor: UIColor.white]
    self.drawAlignedRect(context: context, attributes: drawAttributes, point: point)
  }
  
  func drawAlignedRect(context: CGContext, attributes: [NSAttributedString.Key : Any], point: CGPoint) {
    let text = self.text
    let size = text.size(withAttributes: attributes)
    let drawRect = CGRect(x: point.x - size.width / 2, y: point.y - size.height - 8, width: size.width, height: size.height)
    context.setFillColor(UIColor.gray.cgColor)
    context.beginPath()
    context.move(to: CGPoint(x: drawRect.origin.x, y: drawRect.origin.y))
    context.addLine(to: CGPoint(x: drawRect.origin.x + drawRect.size.width, y: drawRect.origin.y))
    context.addLine(to: CGPoint(x: drawRect.origin.x + drawRect.size.width, y: drawRect.origin.y + drawRect.size.height))
    context.addLine(to: CGPoint(x: drawRect.origin.x, y: drawRect.origin.y + drawRect.size.height))
    context.fillPath()
    
    text.draw(in: drawRect, withAttributes: attributes)
  }

     override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
       super.refreshContent(entry: entry, highlight: highlight)
           text = " \(entry.y)kg"
     }
}



