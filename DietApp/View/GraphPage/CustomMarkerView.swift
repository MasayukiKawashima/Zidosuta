//
//  CustomMarkerView.swift
//  DietApp
//
//  Created by 川島真之 on 2023/08/08.
//

import Foundation
import Charts

protocol CustomMarkerViewDataSource {
  //テキストを作成
  func customMarkerView(
    _ customMarkerView: CustomMarkerView,
    textsInMarker entry: ChartDataEntry,
    highlight: Highlight) -> [NSMutableAttributedString]
  
  //テキストのサイズを元にマーカーのパスを作成
  func customMarkerView(
    _ customMarkerView: CustomMarkerView,
    pathOfMakerCreatedFromTextSize texts: [NSMutableAttributedString],
    context: CGContext,
    point: CGPoint) -> UIBezierPath
  
  //マーカー内のテキストの位置の調整
  func customMarkerView(
    _ customMarkerView: CustomMarkerView,
    adjustedTextCGRects texts: [NSMutableAttributedString],
    markerPath: UIBezierPath) ->  [(textRect: CGRect, text: NSMutableAttributedString)]
  
  //マーカーの背景色の設定
  func markerBackGroundColor(in customMarkerView: CustomMarkerView) -> UIColor
}

class CustomMarkerView: MarkerView {
  var texts: [NSMutableAttributedString]?
  var markerPath: UIBezierPath?
  var dataSource: CustomMarkerViewDataSource?
  
  override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
    super.refreshContent(entry: entry, highlight: highlight)
    
  
    guard let dataSource = dataSource else {
      return
    }
    texts = dataSource.customMarkerView(self, textsInMarker: entry, highlight: highlight)
  }
  
  override func draw(context: CGContext, point: CGPoint) {
    guard let dataSource = dataSource, let texts = texts  else {
      return
    }
    
    markerPath = dataSource.customMarkerView(self, pathOfMakerCreatedFromTextSize: texts, context: context, point: point)
    
    guard let markerPath = markerPath else {
      return
    }
    
    let adjustedTextCGRects = dataSource.customMarkerView(self, adjustedTextCGRects: texts, markerPath: markerPath)
    
    let markerBackGroundColor = dataSource.markerBackGroundColor(in: self)
    
    markerBackGroundColor.setFill()
    markerPath.fill()
    
    
    for rectsInfo in adjustedTextCGRects {
      rectsInfo.text.draw(in: rectsInfo.textRect)
    }
  }
}
