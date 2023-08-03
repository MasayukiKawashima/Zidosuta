//
//  CustomMarkerView.swift
//  DietApp
//
//  Created by 川島真之 on 2023/07/31.
//

import UIKit
import Charts

class CustomMarkerView: MarkerView {
  let index: Int
  let currentDate: Date
  // マーカーのラベルとして表示する文字列
  private var dateWithWeekendText = NSMutableAttributedString()
  private var valueWithKgText = NSMutableAttributedString()
  
  init(index: Int, currentDate: Date = Date()) {
      self.index = index
      self.currentDate = currentDate
      super.init(frame: CGRect.zero)
    }
    
    // このイニシャライザも必要です（Storyboardからの初期化などで使われます）
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  
  // マーカーのラベル内容を更新
  override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
    super.refreshContent(entry: entry, highlight: highlight)
    
    let calendar = Calendar.current
    let results = modifyDate(date: currentDate, index: index)
    let year = calendar.component(.year, from: results)
    let month = calendar.component(.month, from: results)
    let day = Int(entry.x)
    
    let dateComponents = DateComponents(year: year, month: month, day: day)
    guard let date = calendar.date(from: dateComponents) else {
        fatalError("Invalid date components.")
    }
    let weekdayNumber = calendar.component(.weekday, from: date)
    let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let weekDayString = weekDays[weekdayNumber - 1]
    
    //日付を文字列化
    let dateString = "\(month).\(day)"
    //日付と曜日の間の余白のための空の文字列
    let spaceString = " "
    // データの値を文字列化
    let valueString = String(entry.y)
    // 単位を指定
    let kgString = "kg"
    // 日付部分のテキストスタイルを定義
    let dateAttributes: [NSAttributedString.Key : Any] = [
      .font: UIFont.systemFont(ofSize: 16),
      .foregroundColor: UIColor.white
    ]
    let dateAttributedString = NSAttributedString(string: dateString, attributes: dateAttributes)
    
    //余白の装飾(この後の結合処理のためにNSAttributedStringに変換する。装飾内容に意味はない。
    let spaceAttributedString = NSAttributedString(string: spaceString, attributes: dateAttributes)
    
    //曜日部分のテキストスタイルを定義
    let weekDayAttributes: [NSAttributedString.Key : Any] = [
      .font: UIFont.systemFont(ofSize: 14),
      .foregroundColor: UIColor.white
    ]
    let weekDayAttributedString = NSAttributedString(string: weekDayString, attributes: weekDayAttributes)
    
    let dateCombinedText = NSMutableAttributedString()
    dateCombinedText.append(dateAttributedString)
    dateCombinedText.append(spaceAttributedString)
    dateCombinedText.append(weekDayAttributedString)
    
    self.dateWithWeekendText = dateCombinedText
  
    // データ部分のテキストスタイルを定義
    let valueAttributes: [NSAttributedString.Key : Any] = [
      .font: UIFont.systemFont(ofSize: 20),
      .foregroundColor: UIColor.white
    ]
    let valueAttributedString = NSAttributedString(string: valueString, attributes: valueAttributes)
    
    // 単位部分のテキストスタイルを定義
    let kgAttributes: [NSAttributedString.Key : Any] = [
      .font: UIFont.systemFont(ofSize: 15),
      .foregroundColor: UIColor.white
    ]
    let kgAttributedString = NSAttributedString(string: kgString, attributes: kgAttributes)
    
    // データと単位を結合
    let valueCombinedText = NSMutableAttributedString()
    valueCombinedText.append(valueAttributedString)
    valueCombinedText.append(kgAttributedString)
    // ラベルとして設定
    self.valueWithKgText = valueCombinedText
  }
  
  // マーカーを描画
  override func draw(context: CGContext, point: CGPoint) {
    drawMarkerWithTriangle(context: context, point: point)
  }
  
  // マーカー本体と下向き三角を描画
  func drawMarkerWithTriangle(context: CGContext, point: CGPoint) {
    let dateTextSize = dateWithWeekendText.size()
    let valueWithKgTextSize = valueWithKgText.size()
    
    var calculatedX = point.x - valueWithKgTextSize.width / 2 - 4
    let calculatedY = point.y - valueWithKgTextSize.height - dateTextSize.height - 15
    let calculatedWidth = valueWithKgTextSize.width + 8
    let calculatedHeight = valueWithKgTextSize.height + dateTextSize.height + 2
    
    //マーカーのx座標がグラフエリアの領域外になっている場合
    if calculatedX < 0 {
      //x座標をグラフエリアの左端の位置に設定
      //ただしこの方法ではマーカーが画面右端に一部隠れてしまっている場合は対応できない
      calculatedX = 0
    }
    
    let drawRect = CGRect(x: calculatedX, y: calculatedY, width: calculatedWidth, height: calculatedHeight)
    // ラベルの領域に角丸を適用
    let roundedRectPath = UIBezierPath(roundedRect: drawRect, cornerRadius: 3)
    // 下向き三角のサイズを定義
    let triangleSideLength: CGFloat = 10
    // 下向き三角の形状を定義
    let trianglePath = UIBezierPath()
    let triangleOrigin = CGPoint(x: point.x, y: point.y - 7)
    trianglePath.move(to: triangleOrigin)
    trianglePath.addLine(to: CGPoint(x: triangleOrigin.x - triangleSideLength / 2, y: triangleOrigin.y - triangleSideLength))
    trianglePath.addLine(to: CGPoint(x: triangleOrigin.x + triangleSideLength / 2, y: triangleOrigin.y - triangleSideLength))
    trianglePath.close()
    // マーカー本体と下向き三角を結合
    roundedRectPath.append(trianglePath)
    // マーカーの色を設定
    UIColor(red: 72/255, green: 135/255, blue: 191/255, alpha: 0.85).setFill()
    // マーカーを描画
    roundedRectPath.fill()
    // ラベルを描画
    drawTextCenteredInRect(drawRect: drawRect)
  }
  
  // ラベルを中央揃えで描画
  func drawTextCenteredInRect(drawRect: CGRect) {
    
    // 日付テキストのサイズを取得
    let dateSize = dateWithWeekendText.size()
    
    // 体重テキストのサイズを取得
    let valueSize = valueWithKgText.size()
    
    // 体重テキストを中央揃えにするためのパディングを計算
    let valueVerticalPadding = (drawRect.height - valueSize.height - dateSize.height) / 2
    let valueCenteredY = drawRect.origin.y + valueVerticalPadding + dateSize.height
    let valueHorizontalPadding = (drawRect.width - valueSize.width) / 2
    let valueCenteredX = drawRect.origin.x + valueHorizontalPadding
    
    // 日付テキストを中央揃えにするためのパディングを計算
    let dateVerticalPadding = valueVerticalPadding
    let dateCenteredY = drawRect.origin.y + dateVerticalPadding
    let dateHorizontalPadding = (drawRect.width - dateSize.width) / 2
    let dateCenteredX = drawRect.origin.x + dateHorizontalPadding
    
    // 体重テキストを描画する領域を定義
    let valueTextRect = CGRect(x: valueCenteredX, y: valueCenteredY, width: valueSize.width, height: valueSize.height)
    
    // 日付テキストを描画する領域を定義
    let dateTextRect = CGRect(x: dateCenteredX, y: dateCenteredY, width: dateSize.width, height: dateSize.height)
    
    // ラベルを描画
    dateWithWeekendText.draw(in: dateTextRect)
    valueWithKgText.draw(in: valueTextRect)
  }
  //このメソッドは間違っているが一旦保留
  func calculateWeekday(date: Date, index: Int) -> String {
    let modifiedDate = Calendar.current.date(byAdding: .day, value: index, to: date)
    
    let dayOfWeek = Calendar.current.component(.weekday, from: modifiedDate!)
    let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    return weekDays[dayOfWeek - 1]
  }
  //リファクタリング予定
  //DateRangeCalculatorクラスのcalculateMonthHalfDayRangeメソッドと処理が一部重複している
  func modifyDate (date: Date, index: Int) -> Date  {
    let value:Int!
    let calendar = Calendar.current
    //indexの値が偶数＝月の前半なら
    if index % 2 == 0 {
      value = index/2
    }else{
      //indexの値が奇数＝月の後半なら
      value = (index - 1)/2
    }
    
    let modifiedDate = calendar.date(byAdding: .month, value: value, to: date)!
//    let month = calendar.component(.month, from: modifiedDate)
    
    return modifiedDate
  }
}

