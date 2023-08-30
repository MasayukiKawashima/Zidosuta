//
//  CustomMarkerViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/08/08.
//

import UIKit
import Charts

class CustomMarkerViewController: UIViewController, CustomMarkerViewDataSource {
  var index: Int
  
  init(index: Int){
    self.index = index
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  //テキストの作成
  func customMarkerView(_ customMarkerView: CustomMarkerView, textsInMarker entry: ChartDataEntry, highlight: Highlight) -> [NSMutableAttributedString] {
    //日付と曜日の設定
    let calendar = Calendar.current
    let monthAdjuster = MonthAdjuster()
    let modifiedDate = monthAdjuster.adjustMonth(index: index)
    let year = calendar.component(.year, from: modifiedDate)
    let month = calendar.component(.month, from: modifiedDate)
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
    
    // 日付部分のテキストスタイルを定義
    let dateAttributes: [NSAttributedString.Key : Any] = [
      .font: UIFont.systemFont(ofSize: 16),
      .foregroundColor: UIColor.white
    ]
    let dateAttributedString = NSAttributedString(string: dateString, attributes: dateAttributes)
    
    //余白の装飾(この後の結合処理のためにNSAttributedStringに変換する)
    let spaceAttributedString = NSAttributedString(string: spaceString, attributes: dateAttributes)
    
    //曜日部分のテキストスタイルを定義
    let weekDayAttributes: [NSAttributedString.Key : Any] = [
      .font: UIFont.systemFont(ofSize: 14),
      .foregroundColor: UIColor.white
    ]
    let weekDayAttributedString = NSAttributedString(string: weekDayString, attributes: weekDayAttributes)
    //日付、余白、曜日を結合
    let dateCombinedText = NSMutableAttributedString()
    dateCombinedText.append(dateAttributedString)
    dateCombinedText.append(spaceAttributedString)
    dateCombinedText.append(weekDayAttributedString)
    
    //体重データと単位を設定
    // データの値を文字列化
    let valueString = String(entry.y)
    // 単位を指定
    let kgString = "kg"
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
    
    //CustomMakerViewにデータを渡す
    var texts: [NSMutableAttributedString] = []
    texts.append(dateCombinedText)
    texts.append(valueCombinedText)
    
    return texts
  }
  //テキストのサイズをもとにMakerを作成
  func customMarkerView(_ customMarkerView: CustomMarkerView, pathOfMakerCreatedFromTextSize texts: [NSMutableAttributedString], context: CGContext, point: CGPoint) -> UIBezierPath {
    let dateTextSize = texts[0].size()
    let valueWithKgTextSize = texts[1].size()
    //Makerの基本の位置とサイズを定義
    var calculatedX = point.x - valueWithKgTextSize.width / 2 - 4
    var calculatedY = point.y - valueWithKgTextSize.height - dateTextSize.height - 10
    let calculatedWidth = valueWithKgTextSize.width + 8
    let calculatedHeight = valueWithKgTextSize.height + dateTextSize.height + 2
    
    //デバイスの画面の大きさを取得
    let screenSize = UIScreen.main.bounds.size
    // 右端にはみ出す場合の調整
    if calculatedX + calculatedWidth > screenSize.width {
      calculatedX = screenSize.width - calculatedWidth
    }
    // 左端にはみ出す場合の調整
    if calculatedX < 0 {
      calculatedX = 0
    }
    //下端にはみ出す場合の調整
    if calculatedY + calculatedHeight > screenSize.height {
      calculatedY = screenSize.height - calculatedHeight
    }
    // 上端にはみ出す場合の調整
    if calculatedY < 0 {
      calculatedY = 0
    }
    let drawRect = CGRect(x: calculatedX, y: calculatedY, width: calculatedWidth, height: calculatedHeight)
    // ラベルの領域に角丸を適用
    let roundedRectPath = UIBezierPath(roundedRect: drawRect, cornerRadius: 3)
    
    return roundedRectPath
  }
  //マーカー内のテキストの位置の調整
  func customMarkerView(_ customMarkerView: CustomMarkerView, adjustedTextCGRects texts: [NSMutableAttributedString], markerPath: UIBezierPath) -> [(textRect: CGRect, text: NSMutableAttributedString)] {
    //日付テキストのサイズ取得
    let dateSize = texts[0].size()
    
    // 体重テキストのサイズを取得
    let valueSize = texts[1].size()
    
    //パスの高さや幅の情報の取得
    let boundingBox = markerPath.bounds
    
    // 体重テキストを中央揃えにするためのパディングを計算
    let valueVerticalPadding = (boundingBox.height - valueSize.height - dateSize.height) / 2
    let valueCenteredY = boundingBox.origin.y + valueVerticalPadding + dateSize.height
    let valueHorizontalPadding = (boundingBox.width - valueSize.width) / 2
    let valueCenteredX = boundingBox.origin.x + valueHorizontalPadding
    
    // 日付テキストを中央揃えにするためのパディングを計算
    let dateVerticalPadding = valueVerticalPadding
    let dateCenteredY = boundingBox.origin.y + dateVerticalPadding
    let dateHorizontalPadding = (boundingBox.width - dateSize.width) / 2
    let dateCenteredX = boundingBox.origin.x + dateHorizontalPadding
    
    // 日付テキストを描画する領域を定義
    let dateTextRect = CGRect(x: dateCenteredX, y: dateCenteredY, width: dateSize.width, height: dateSize.height)
    let dateTextRectWithText = (dateTextRect,  texts[0])
    // 体重テキストを描画する領域を定義
    let valueTextRect = CGRect(x: valueCenteredX, y: valueCenteredY, width: valueSize.width, height: valueSize.height)
    let valueTextRectWithText = (valueTextRect, texts[1])

    var textRects: [(textRect: CGRect, text: NSMutableAttributedString)] = []
    textRects.append(dateTextRectWithText)
    textRects.append(valueTextRectWithText)
    
    return textRects
  }
  //色を指定
  func markerBackGroundColor(in customMarkerView: CustomMarkerView) -> UIColor {
    return UIColor(red: 72/255, green: 135/255, blue: 191/255, alpha: 0.85)
  }
}
