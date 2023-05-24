//
//  TopViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/23.
//

import UIKit

class TopViewController: UIViewController {

  @IBOutlet weak var NavigatioItem: UINavigationItem!
  
  override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    navigatoBarTitleSetting()
    
    }
  //5.24NavigationBarのタイトルを仮配置した。各タイトルの設定（テキスト表示のアルゴリズム、フォントサイズ、AutoLayout等）この関数のモデル化等を後日検討
  //NavigationBarのタイトル設定
  func navigatoBarTitleSetting (){
  
    let yearText = "2023"
    let dateText = "5.24"
    let dayOfWeekText = "wed"
    
    let dateFontSize: CGFloat = 18.0
    let fontSize: CGFloat = 14.0
    
    // 各テキストのNSAttributedStringを作成
    let attributedYearText = NSAttributedString(string: yearText, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)])
    
    let attributedDateText = NSAttributedString(string: dateText, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: dateFontSize)])
    
    let attributedDayOfWeekText = NSAttributedString(string: dayOfWeekText, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)])
    
    // カスタムビューをインスタンス化
    let customTitleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    
    // UILabelを作成してテキストを設定
    let yearTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 22))
    yearTextLabel.attributedText = attributedYearText
    yearTextLabel.sizeToFit()
    
    let dateTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 22))
    dateTextLabel.attributedText = attributedDateText
    dateTextLabel.sizeToFit()
    
    let dayOfWeekTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 22))
    dayOfWeekTextLabel.attributedText = attributedDayOfWeekText
    dayOfWeekTextLabel.sizeToFit()
    
    
    //AutoLayoutを使用するための設定
    yearTextLabel.translatesAutoresizingMaskIntoConstraints = false
    dateTextLabel.translatesAutoresizingMaskIntoConstraints = false
    dayOfWeekTextLabel.translatesAutoresizingMaskIntoConstraints = false
    
    
    // カスタムビューにUILabelを追加
    customTitleView.addSubview(yearTextLabel)
    customTitleView.addSubview(dateTextLabel)
    customTitleView.addSubview(dayOfWeekTextLabel)
    
    
    //AutoLayoutの設定
    NSLayoutConstraint.activate([
      
      //yearTextLabelの上端は親ViewであるcustomTitleViewの上端より１０ポイント（１０ポイント下）になるように制約する
      yearTextLabel.topAnchor.constraint(equalTo: customTitleView.topAnchor, constant: 10),
      //この制約については後日確認
      yearTextLabel.leadingAnchor.constraint(equalTo: yearTextLabel.leadingAnchor),
      //yearTextLabelの右端は隣のラベルであるdateTextLabelの左端より−８ポイント（８ポイント左）になるように制約する
      yearTextLabel.trailingAnchor.constraint(equalTo: dateTextLabel.leadingAnchor, constant:  -8.0),
      
      dateTextLabel.topAnchor.constraint(equalTo: customTitleView.topAnchor, constant: 10),
      dateTextLabel.trailingAnchor.constraint(equalTo: dayOfWeekTextLabel.leadingAnchor, constant: -8.0),
      dateTextLabel.centerXAnchor.constraint(equalTo: customTitleView.centerXAnchor),
      
      dayOfWeekTextLabel.topAnchor.constraint(equalTo: customTitleView.topAnchor, constant: 10),
      dayOfWeekTextLabel.trailingAnchor.constraint(equalTo: dayOfWeekTextLabel.trailingAnchor)
      
    ])
    
    //カスタムビューをNavigationBarに追加
    self.NavigatioItem.titleView = customTitleView
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
