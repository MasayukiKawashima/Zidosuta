//
//  TopViewController.swift
//  DietApp
//
//  Created by 川島真之 on 2023/05/23.
//

import UIKit
import RealmSwift

class TopViewController: UIViewController {
  var topView = TopView()
  
  var topDateManager = TopDateManager()
  
  var documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  
  let realm = try! Realm()
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    return .portrait
  }
  
  var tabBarHeight: CGFloat {
    return tabBarController?.tabBar.frame.size.height ?? 49.0
  }
  
  var navigationBarHeight: CGFloat {
    return self.navigationController!.navigationBar.frame.size.height
  }
  
  var statusBarHeight: CGFloat {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let statusBarFrame = windowScene.statusBarManager?.statusBarFrame {
      return statusBarFrame.height
    }
    return 0
  }
  //各セルの高さの定義
  var weightTableViewCellHeight:CGFloat = 70.0
  var memoTableViewCellHeight:CGFloat = 47.0
  var photoTableViewCellHeight: CGFloat {
    return view.frame.height - tabBarHeight - navigationBarHeight - statusBarHeight - weightTableViewCellHeight - memoTableViewCellHeight - adTableViewCellHeight
  }
  var adTableViewCellHeight:CGFloat = 53.0
  
  //セル周り設定用の列挙体
  enum TopPageCell: Int {
    case weightTableViewCell = 0
    case memoTableViewCell
    case photoTableViewCell
    case adTableViewCell
  }
  
  enum TopPageTextFieldType: Int {
    case weight = 3
    case memo = 4
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    //    topView.navigationBar.delegate = self
    topView.tableView.delegate = self
    topView.tableView.dataSource = self
    //tableViewでタップ認識させるための設定
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(dismissKeyboard))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
    
    //スクロールできないようにする
    topView.tableView.isScrollEnabled = false
    //tableViewCellの高さの自動設定
    topView.tableView.rowHeight = UITableView.automaticDimension
    //セル間の区切り線を非表示
    topView.tableView.separatorStyle = .none
  }
  
  override func loadView() {
    view = topView
  }
  
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    print("viewWillAppearがよばれた")
//    dateResourceSetting()
//  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
}
//TableViewの設定
extension TopViewController: UITableViewDelegate,UITableViewDataSource {
  //TableViewのセクション内のセルの数（5.28時点で１セクション、４セル）
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  //各セルを内容を設定し表示
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = TopPageCell(rawValue: indexPath.row)
    
    switch (cell)! {
    case .weightTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: "WeightTableViewCell", for: indexPath) as! WeightTableViewCell
      //セルの選択時のハイライトを非表示にする
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      cell.weightTextField.delegate = self
      cell.delegate = self
      
      let dateDataRealmSearcher = DateDataRealmSearcher()
      let results = dateDataRealmSearcher.searchForDateDataInRealm(currentDate: topDateManager.date)
      let resultsCount = results.count
      
      if resultsCount != 0 {
        let weightString = String(results.first!.weight)
        cell.weightTextField.text = weightString
      }
      
      return cell
      
    case .memoTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell", for: indexPath) as! MemoTableViewCell
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      cell.memoTextField.delegate = self
      
      let dateDataRealmSearcher = DateDataRealmSearcher()
      let results = dateDataRealmSearcher.searchForDateDataInRealm(currentDate: topDateManager.date)
      let resultsCount = results.count
      
      if resultsCount != 0 {
        cell.memoTextField.text = results.first!.memoText
      }
      
      return cell
      
    case .photoTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as! PhotoTableViewCell
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      //写真セルのデリゲート
      cell.delegate = self
            
      let dateDataRealmSearcher = DateDataRealmSearcher()
      let results = dateDataRealmSearcher.searchForDateDataInRealm(currentDate: topDateManager.date)
      let resultsCount = results.count
      
      if resultsCount != 0 {
        //fileURLが存在するかどうか確認
        if results.first!.photoFileURL != "" {
          //存在したら
          let documentPath = documentDirectoryFileURL.appendingPathComponent(results.first!.photoFileURL)
          let filePath = documentPath.path
          //合体パスをもとに写真のロード
          let photoImage = UIImage(contentsOfFile: filePath)!
          //ロードした写真に回転情報の付与するため、一度CGImageに変換する
          let cgImage = photoImage.cgImage
          let imageOrientation = UIImage.Orientation(rawValue: results.first!.imageOrientationRawValue)
          //その後再度UIImageの初期化
          let orientedPhotoImage = UIImage(cgImage: cgImage!, scale: 1.0, orientation: imageOrientation!)
          //写真表示Viewに写真を格納
          cell.photoImageView.image = orientedPhotoImage
          //挿入ボタンとコメントラベルを非表示
          cell.insertButton.isHidden = true
          cell.commentLabel.isHidden = true
          //やり直しボタンの非表示を解除
          cell.redoButton.isHidden = false
        }
      }
      return cell
      
    case .adTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: "AdTableViewCell", for: indexPath) as! AdTableViewCell
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      return cell
    }
  }
  //各セルの高さの推定値を設定
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    let cell = TopPageCell(rawValue: indexPath.row)
    
    switch (cell)! {
    case .weightTableViewCell:
      return weightTableViewCellHeight
      
    case .memoTableViewCell:
      return memoTableViewCellHeight
      
    case .photoTableViewCell:
      return photoTableViewCellHeight
      
    case .adTableViewCell:
      return adTableViewCellHeight
    }
  }
  //セルの高さの設定
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cell = TopPageCell(rawValue: indexPath.row)
    
    switch (cell)! {
    case .weightTableViewCell:
      return weightTableViewCellHeight
      
    case .memoTableViewCell:
      return memoTableViewCellHeight
      
    case .photoTableViewCell:
      return photoTableViewCellHeight
      
    case .adTableViewCell:
      return adTableViewCellHeight
    }
  }
}
//UITextField周りの処理
//エンターを押したらキーボードを閉じる処理
extension TopViewController: WeightTableViewCellDelegate {
  func weightTableViewCellDidRequestKeyboardDismiss(_ cell: WeightTableViewCell) {
    view.endEditing(true)
  }
  
  //キーボード以外の領域をタッチしたらキーボードを閉じる処理
  @objc public func dismissKeyboard() {
    view.endEditing(true)
  }
}
//写真セル内のボタン押下時処理
extension TopViewController: PhotoTableViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  //写真挿入ボタンとやり直しボタンを押した時の処理
  func insertButtonAction() {
    showPhotoSelectionActionSheet()
  }
  //写真がダブルタップされた時の処理
  func photoDoubleTapAction(photoImage: UIImage) {
    showPhotoModal(photoImage: photoImage)
  }
  //モーダル表示するメソッド
  func showPhotoModal(photoImage: UIImage) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let photoModalVC = storyboard.instantiateViewController(withIdentifier: "PhotoModalVC") as? PhotoModalViewController {
      photoModalVC.modalPresentationStyle = .fullScreen
      photoModalVC.photoModalView.photoImageView.image = photoImage
      self.present(photoModalVC, animated: true, completion: nil)
    }
  }
  //カメラ及びフォトライブラリでキャンセルしたときのデリゲートメソッド
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  //UIImagePickerController内で画像を選択したときの処理
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let pickedImage = info[.originalImage] as? UIImage {
      //保存した
      let fileName = "\(NSUUID().uuidString)"
      //後にファイル名だけをrealmに保存する
      let photoFileName = fileName
      
      //フルパスを作成
      let path = documentDirectoryFileURL.appendingPathComponent(fileName)
      
      //取得した写真の保存処理
      saveImageToDocument(pickedImage: pickedImage, path: path)
      
      //現在のページの日付のRealmObjectが存在するか検索
      let dateDataRealmSearcher = DateDataRealmSearcher()
      let results = dateDataRealmSearcher.searchForDateDataInRealm(currentDate: topDateManager.date)
      let resultsCount = results.count
      
      let realm = try! Realm()
      //存在した場合
      if resultsCount != 0 {
        //そのRealmObjectのphotoFileURLに古い写真のFileURLが登録されていたら
        if results.first!.photoFileURL != "" {
          //その古い写真を削除する
          let documentPath = documentDirectoryFileURL.appendingPathComponent(results.first!.photoFileURL)
          do {
              try FileManager.default.removeItem(at: documentPath)
          } catch {
              print("ファイルの削除に失敗しました: \(error)")
          }
        }
        try! realm.write {
          results.first!.photoFileURL = photoFileName
          results.first!.imageOrientationRawValue = pickedImage.imageOrientation.rawValue
        }
      }
      //存在しなかった場合
      //新しいRealObjectを現在のページの日付で登録
      let dateData = DateData()
      dateData.imageOrientationRawValue = pickedImage.imageOrientation.rawValue
      dateData.photoFileURL = photoFileName
      dateData.date = topDateManager.date
      try! realm.write {
        realm.add(dateData)
      }
      //取得した写真の表示処理
      //現在表示されているPhotoTAbleViewCellのインスタンス取得
      let photoTableViewCell = topView.tableView.visibleCells[2] as! PhotoTableViewCell
      //ボタンとコメントラベルを非表示にする
      photoTableViewCell.insertButton.isHidden = true
      photoTableViewCell.commentLabel.isHidden = true
      //やり直しボタンを解除する
      photoTableViewCell.redoButton.isHidden = false
      //取得したインスタンスのimageに選択した写真を格納
      photoTableViewCell.photoImageView.image = pickedImage
    }
    //UIImagePickerControllerを閉じる
    picker.dismiss(animated: true, completion: nil)
  }
  
  //アクションシートの表示
  func showPhotoSelectionActionSheet() {
    let actionSheet = UIAlertController(title: "写真の選択", message: nil, preferredStyle: .actionSheet)
    
    let cameraAction = UIAlertAction(title: "カメラ", style: .default) { action in
      self.showImagePicker(sourceType: .camera)
    }
    let photoLibraryAction = UIAlertAction(title: "フォトライブラリ", style: .default) { action in
      self.showImagePicker(sourceType: .photoLibrary)
    }
    let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
    
    actionSheet.addAction(cameraAction)
    actionSheet.addAction(photoLibraryAction)
    actionSheet.addAction(cancelAction)
    
    self.present(actionSheet, animated: true, completion: nil)
  }
  
  //ImagePickerControllerの表示
  func showImagePicker(sourceType: UIImagePickerController.SourceType) {
    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
      let imagePicker = UIImagePickerController()
      imagePicker.sourceType = sourceType
      imagePicker.delegate = self
      self.present(imagePicker, animated: true, completion: nil)
    }
  }
  
  //写真をドキュメントに保存するメソッド
  func saveImageToDocument(pickedImage: UIImage, path: URL) {
    
    let pngImageData = pickedImage.pngData()
    do {
      try pngImageData!.write(to: path)
    } catch {
      print("画像をドキュメントに保存できませんでした")
    }
  }
  //写真のファイルと、ドキュメントへの保存のためフルパスの作成
}
//各TextFieldのイベント処理
extension TopViewController: UITextFieldDelegate {
  //リターンが押されたとき
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  //テキストフィールドの編集が終了した時
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    guard let text = textField.text, !text.isEmpty else { return }
    guard let result = textFieldValidate(textField) else{ return }
    guard let type = TopPageTextFieldType(rawValue: textField.tag) else { return }
    
    switch result {
    case .valid:
      let dateDataRealmSearcher = DateDataRealmSearcher()
      let results = dateDataRealmSearcher.searchForDateDataInRealm(currentDate: topDateManager.date)
      
      switch type {
      case .weight:
        handleWeightTextFieldEditing(with: results, text: textField.text)
      case .memo:
        handleMemoTextFieldEditing(with: results, text: textField.text)
      }
    case .invalid(let error):
      showValidationErrorAlert(errorText: error.localizedDescription, textField: textField)
      
    }
  }
  
  //テキストフィールドのバリデート
  func textFieldValidate(_ textField : UITextField) -> ValidationResult? {
    
    guard let type = TopPageTextFieldType(rawValue: textField.tag) else { return nil }
    
    switch type {
    case .weight:
      let weightInputValidator = WeightInputValidator(text: textField.text!)
      switch weightInputValidator.validate() {
      case .valid:
        print("体重は問題なし")
        return .valid
      case .invalid(let error):
        return .invalid(error)
      }
      
    case .memo:
      let memoInputValidator = MemoInputValidator(text: textField.text!)
      switch memoInputValidator.validate() {
      case .valid:
        print("メモは問題なし")
        return .valid
      case .invalid(let error):
        return .invalid(error)
      }
    }
  }
  //バリデーションエラーのアラートを表示する
  func showValidationErrorAlert(errorText: String, textField: UITextField) {
    let alert = UIAlertController(title: "", message: errorText, preferredStyle: .alert)
    
    let attributedTitle = NSAttributedString(string: "入力エラー", attributes: [
      .foregroundColor: UIColor.red,
      .font: UIFont.boldSystemFont(ofSize: 18) // ボールドフォント
    ])
    alert.setValue(attributedTitle, forKey: "attributedTitle")
    
    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
      //キーボードを表示
      textField.becomeFirstResponder()
      //テキストを空にする
      textField.text = ""
      //アラートを閉じる
      alert.dismiss(animated: true, completion: nil)
    }
    alert.addAction(okAction)
    
    self.present(alert, animated: true, completion: nil)
  }
  
  private func handleWeightTextFieldEditing(with results: Results<DateData>, text: String?) {
    let realm = try! Realm()
    //テキストフィールドに入力された値がnilじゃないか確認
    if let text = text {
      //空文字（"")でもないかを確認
      if !text.isEmpty {
        //nilでも空文字でもなかった場合
        let weightDouble = Double(text)!
        //Realmのデータがあるかどうかで分岐
        if results.isEmpty {
          //データが無い場合
          let dateData = DateData()
          dateData.date = topDateManager.date
          dateData.weight = weightDouble
          try! realm.write {
            realm.add(dateData)
          }
          print("新しい体重データが作成されました")
        } else {
          //データがある場合
          try! realm.write {
            results[0].weight = weightDouble
            print("体重データを更新しました")
          }
        }
      } else {
        //空文字でRealmのデータもない場合
        if results.isEmpty {
          print("体重データなし。体重が未入力です")
        } else {
          //Realmのデータはある場合
          //Realmのデータはあるのに、テキストフィールドを空にした　→ データを消去したいということ
          try! realm.write {
            results[0].weight = 0
            print("体重データを消去しました")
          }
        }
      }
    } else {
      print("なんらかの理由で体重テキストフィールドに入力された値がnilになりました")
      return
    }
  }
  
  private func handleMemoTextFieldEditing(with results: Results<DateData>, text: String?) {
    let realm = try! Realm()
    //テキストがnilじゃないかを確認
    if let text = text {
      //テキストが空文字じゃないかを確認
      if !text.isEmpty {
        //空文字じゃなければ
        //Realmのデータがあるかを確認
        if results.isEmpty {
          //データがなければ
          let dateData = DateData()
          dateData.date = topDateManager.date
          dateData.memoText = text
          try! realm.write {
            realm.add(dateData)
          }
          print("新しいメモデータが作成されました")
        } else {
          //データあれば
          try! realm.write {
            results[0].memoText = text
            print("メモデータを更新しました")
          }
        }
      } else {
        //Realmのデータがない場合
        if results.isEmpty {
          print("メモデータなし。メモが未入力です")
        } else {
          //Realmのデータはある場合
          //Realmのデータはあるのに、テキストフィールドを空にした　→ データを消去したいということ
          try! realm.write {
            results[0].memoText = ""
            print("メモデータを消去しました")
          }
        }
      }
    }else {
      print("なんらかの理由でメモテキストフィールドに入力された値がnilになりました")
      return
    }
  }
  //以下のコメントアウトは少しの間保管する（2024.10.31 〜）
  //textFieldDidEndEditing内の処理をリファレンスしたので、挙動を少しの間確認したい
  //キーボードが閉じたとき
//  func textFieldDidEndEditing(_ textField: UITextField) {
//    let dateDataRealmSearcher = DateDataRealmSearcher()
//    let results = dateDataRealmSearcher.searchForDateDataInRealm(currentDate: topDateManager.date)
//    let resultsCount = results.count
//    //体重が入力された場合
//    if textField.tag == 3 {
//      //入力された文字が空の場合
//      if textField.text == "" {
//        //データがなければ
//        if (resultsCount == 0) {
//          print("データなし。体重が未入力です")
//        }else{
//          //入力された文字が空であり、データが存在している＝その日付のデータを消したい（空にしたい）ということ
//          //なのでレラムインスタンスを作り、データの上書き＝データを消す
//          let realm = try! Realm()
//          try! realm.write() {
//            results[0].weight = 0
//            print("体重データを消去しました")
//          }
//        }
//        //文字列が空じゃなかったら
//      }else{
//        let realm = try! Realm()
//        //そして今日の日付のデータも存在しなかったら
//        if (resultsCount == 0) {
//          //今日の日付のデータを作る
//          let dateData = DateData()
//          
//          dateData.date = topDateManager.date
//          let weightDouble = Double(textField.text!)!
//          dateData.weight = weightDouble
//          try! realm.write {
//            realm.add(dateData)
//          }
//          //もしデータがあれば更新
//        }else{
//          try! realm.write() {
//            let weightDouble = Double(textField.text!)!
//            results[0].weight = weightDouble
//            print("体重を更新しました")
//          }
//        }
//      }
//    }
//    //メモが入力されたとき
//    if textField.tag == 4 {
//      if textField.text == "" {
//        //データがなければ
//        if (resultsCount == 0) {
//          print("データなし。メモが未入力です")
//        }else{
//          //入力された文字が空であり、データが存在している＝その日付のデータを消したい（空にしたい）ということ
//          //なのでレラムインスタンスを作り、データの上書き＝データを消す
//          let realm = try! Realm()
//          try! realm.write() {
//            results[0].memoText = textField.text!
//            print("メモを消去しました")
//          }
//        }
//        //文字列が空じゃなかったら
//      }else{
//        let realm = try! Realm()
//        //そして今日の日付のデータも存在しなかったら
//        if (resultsCount == 0) {
//          //今日の日付のデータを作る
//          let dateData = DateData()
//          dateData.date = topDateManager.date
//          dateData.memoText = textField.text!
//          try! realm.write {
//            realm.add(dateData)
//          }
//          print("あたらしいRealmオブジェクトが生成され、メモが追加されました")
//          //もしデータがあれば更新
//        }else{
//          try! realm.write() {
//            results[0].memoText = textField.text!
//            print("メモを更新しました")
//          }
//        }
//      }
//    }
//  }
}
