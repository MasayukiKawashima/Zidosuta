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
  
  private var navigationBarCover: UIView?
  private var viewCover: UIView?
  private var tabBarCover: UIView?
  
  var topDateManager = TopDateManager()
  
  var documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  
  let realm = try! Realm()
  var notificationToken: NotificationToken?
  //全データ削除後の更新処理のためプロパティ
  var shouldReloadDataAfterDeletion: Bool = false
  //初回レイアウトが完了しているかどうか
  //全データ削除後のテーブルビューのリロードをするかどうかの分岐で使用する
  var isViewFirstLayoutFinished = false
  
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
    return self.navigationController?.navigationBar.frame.size.height ?? 44.0
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
       let totalHeight = view.frame.height
       let navigationHeight = navigationBarHeight
       let statusHeight = statusBarHeight
       let tabHeight = tabBarHeight
       let adHeight = adTableViewCellHeight
       
       return totalHeight - navigationHeight - statusHeight - tabHeight - weightTableViewCellHeight - memoTableViewCellHeight - adHeight
   }
  var adTableViewCellHeight:CGFloat = 53.0
  
  //セル周り設定用の列挙体
  enum TopPageCell: Int {
    case weightTableViewCell = 0
    case memoTableViewCell
    case photoTableViewCell
    case adTableViewCell
  }
  //テキストフィールドのタグの意味を示す列挙体
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
    //キーボードの表示と非表示の監視
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    //スクロールできないようにする
    topView.tableView.isScrollEnabled = false
    //tableViewCellの高さの自動設定
    topView.tableView.estimatedRowHeight = UITableView.automaticDimension
    topView.tableView.rowHeight = UITableView.automaticDimension
    //セル間の区切り線を非表示
    topView.tableView.separatorStyle = .none
    
    setupRealmObserver()
  }
  
  private func setupRealmObserver() {
    let dateData = realm.objects(DateData.self)
    
    notificationToken = dateData.observe { changes in
      switch changes {
      case .update:
        if dateData.isEmpty && !self.shouldReloadDataAfterDeletion {
          self.shouldReloadDataAfterDeletion = true
        }
      case .initial:
        return
      case .error(let error):
        print("RealmObject監視でのエラー: \(error)")
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if shouldReloadDataAfterDeletion {
      //レイアウトが完了しているかどうか
      //この分岐をしないと、Viewのレイアウトが完了していない状態でtableView.reloadData()を実行してしまい
      //cellの高さを計算する時に不正な値が算出されてしまいアプリがクラッシュしてしまうことがある
      if isViewFirstLayoutFinished {
        // レイアウト更新後にリロードを実行
        self.topView.tableView.reloadData()
        print("tableViewのリロード！！！！！！！")
        self.shouldReloadDataAfterDeletion = false
      }
    }
  }
  
  override func loadView() {
    view = topView
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    //初回レイアウトが完了
    isViewFirstLayoutFinished = true
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
      
      if results.isEmpty {
        cell.weightTextField.text = ""
      } else {
        let weightString = String(results.first!.weight)
        cell.weightTextField.text = weightString
      }
      
//      if resultsCount != 0 {
//        let weightString = String(results.first!.weight)
//        cell.weightTextField.text = weightString
//      }
      
      return cell
      
    case .memoTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell", for: indexPath) as! MemoTableViewCell
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      cell.memoTextField.delegate = self
      cell.delegate = self
      
      let dateDataRealmSearcher = DateDataRealmSearcher()
      let results = dateDataRealmSearcher.searchForDateDataInRealm(currentDate: topDateManager.date)
      
      if results.isEmpty {
        cell.memoTextField.text = ""
      } else {
        cell.memoTextField.text = results.first!.memoText
      }
      
//      if resultsCount != 0 {
//        cell.memoTextField.text = results.first!.memoText
//      }
      
      return cell
      
    case .photoTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as! PhotoTableViewCell
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      //写真セルのデリゲート
      cell.delegate = self
      //テキストカラーをダークグレイに再設定
    //写真読み込み時にテキストカラーが.redに変更されるため
      cell.commentLabel.textColor = .darkGray
            
      let dateDataRealmSearcher = DateDataRealmSearcher()
      let results = dateDataRealmSearcher.searchForDateDataInRealm(currentDate: topDateManager.date)
      if results.isEmpty {
        cell.photoImageView.image = nil
      } else if results.first!.photoFileURL != "" {
        let documentPath = documentDirectoryFileURL.appendingPathComponent(results.first!.photoFileURL)
        let filePath = documentPath.path
        if let photoImage = UIImage(contentsOfFile: filePath) {
          let cgImage = photoImage.cgImage
          let imageOrientation = UIImage.Orientation(rawValue: results.first!.imageOrientationRawValue)
          let orientedPhotoImage = UIImage(cgImage: cgImage!, scale: 1.0, orientation: imageOrientation!)
          cell.photoImageView.image = orientedPhotoImage
        } else { //画像ファイルの読み込みに失敗した時の処理
          cell.photoImageView.image = nil
          cell.commentLabel.text = "読み込みエラー。写真の再セットをお願いします。"
          cell.commentLabel.textColor = .red
        }
      } else {
        cell.photoImageView.image = nil
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
extension TopViewController: WeightTableViewCellDelegate, MemoTableViewCellDelegate {
  //notificationCenterのメソッド
  func weightTableViewCellDidRequestKeyboardDismiss(_ cell: WeightTableViewCell) {
    view.endEditing(true)
  }
  func memoTableViewCellDidRequestKeyboardDismiss(_ cell: MemoTableViewCell) {
    view.endEditing(true)
  }
}
//写真セル内のボタン押下時処理
extension TopViewController: PhotoTableViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  //拡大ボタンが押された時の処理
  func expandButtonAction(photoImage: UIImage) {
    showPhotoModal(photoImage: photoImage)
  }
  //削除ボタンが押された時の処理
  func deleteButtonAction(in cell: PhotoTableViewCell) {
    let alert = UIAlertController(title: nil, message: "写真を削除してもよろしいですか？", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "削除する", style: .destructive) { _ in
      self.deleteAlertAction(cell)
    }
    let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)

    alert.addAction(cancelAction)
    alert.addAction(okAction)
    present(alert, animated: true)
  }
  //削除ボタンが押された時の確認のアラート
  func deleteAlertAction(_ cell: PhotoTableViewCell) {
    let dateDataRealmSearcher = DateDataRealmSearcher()
    let results = dateDataRealmSearcher.searchForDateDataInRealm(currentDate: topDateManager.date)
    let resultsCount = results.count
    
    let realm = try! Realm()
    if resultsCount != 0 {
      if results.first!.photoFileURL != "" {
        //ドキュメント内の写真を削除する
        let documentPath = documentDirectoryFileURL.appendingPathComponent(results.first!.photoFileURL)
        do {
          try FileManager.default.removeItem(at: documentPath)
        } catch {
          print("ファイルの削除に失敗しました: \(error)")
        }
        //Realmからも写真パスと写真の方向データを削除する
        try! realm.write {
          results.first!.photoFileURL = ""
          results.first!.imageOrientationRawValue = Int()
        }
        //Viewから写真を削除し
        cell.photoImageView.image = nil
      }
    }
  }
  
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
//      //ボタンとコメントラベルを非表示にする
//      photoTableViewCell.insertButton.isHidden = true
//      photoTableViewCell.commentLabel.isHidden = true
//      //各種ボタンの非表示を解除する
//      photoTableViewCell.redoButton.isHidden = false
//      photoTableViewCell.deleteButton.isHidden = false
//      photoTableViewCell.expandButton.isHidden = false
      //取得したインスタンスのimageに選択した写真を格納
      photoTableViewCell.photoImageView.image = pickedImage
    }
    //UIImagePickerControllerを閉じる
    picker.dismiss(animated: true, completion: nil)
  }
  
  //アクションシートの表示
  func showPhotoSelectionActionSheet() {
    let actionSheet = UIAlertController(title: "写真の選択", message: nil, preferredStyle: .actionSheet)
    
    actionSheet.view.accessibilityIdentifier = "photoSelectionSheet"
    
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
}
//各TextFieldのイベント処理
extension TopViewController: UITextFieldDelegate {
  //各種カバービューを作成し配置
  func createCoverViews() {
    addNavigationBarCover()
    addViewCover()
    addTabBarCover()
  }
  //カバービューを削除
  func removeCoverviews() {
    navigationBarCover?.removeFromSuperview()
    navigationBarCover = nil
    
    viewCover?.removeFromSuperview()
    viewCover = nil
    
    tabBarCover?.removeFromSuperview()
    tabBarCover = nil
  }
  //個別のカバービューの生成と配置
  private func addNavigationBarCover() {
    guard navigationBarCover == nil, let navigationBar = navigationController?.navigationBar else { return }
    
    let coverView = UIView(frame: navigationBar.bounds)
    coverView.backgroundColor = UIColor.clear
    coverView.isUserInteractionEnabled = true
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    coverView.addGestureRecognizer(tapGesture)
    
    navigationBar.addSubview(coverView)
    navigationBarCover = coverView
  }
  
  private func addViewCover() {
    guard viewCover == nil else { return }
    
    let coverView = UIView(frame: view.bounds)
    coverView.backgroundColor = UIColor.clear
    coverView.isUserInteractionEnabled = true
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    coverView.addGestureRecognizer(tapGesture)
    
    view.addSubview(coverView)
    viewCover = coverView
  }
  
  private func addTabBarCover() {
    guard tabBarCover == nil, let tabBar = tabBarController?.tabBar else { return }
    
    let coverView = UIView(frame: tabBar.bounds)
    coverView.backgroundColor = UIColor.clear
    coverView.isUserInteractionEnabled = true
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    coverView.addGestureRecognizer(tapGesture)
    
    tabBar.addSubview(coverView)
    tabBarCover = coverView
  }
  
  @objc private func dismissKeyboard() {
     view.endEditing(true)
   }
  @objc private func keyboardWillShow(_ notification: Notification) {
    //カバービューの生成と配置をする
    //textFieldDidBeginEditing(_ textField: UITextField)でも同様の処理を行う
    createCoverViews()
  }
  
  @objc private func keyboardWillHide(_ notification: Notification) {
    //カバービューの削除
    //textFieldDidEndEditingでも同様の処理を行う
    removeCoverviews()
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    //各種カバービューがまだ生成されていなかったら、カバービューの生成と配置をする
    //カバービューの生成と配置自体はkeyboardWillShow(_ notification: Notification)でも行っている
    if navigationBarCover == nil && viewCover == nil && tabBarCover == nil {
      createCoverViews()
    }
  }
  
  //リターンが押されたとき
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {

    textField.resignFirstResponder()
    return true
  }
  
  //テキストフィールドの編集が終了した時
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    guard let text = textField.text else { return }
    guard let result = textFieldValidate(textField) else { return }
    guard let type = TopPageTextFieldType(rawValue: textField.tag) else { return }
    
    switch result {
    case .valid:
      let dateDataRealmSearcher = DateDataRealmSearcher()
      let results = dateDataRealmSearcher.searchForDateDataInRealm(currentDate: topDateManager.date)
      
      switch type {
      case .weight:
        handleWeightTextFieldEditing(with: results, text: text)
      case .memo:
        handleMemoTextFieldEditing(with: results, text: text)
      }
    case .invalid(let error):
      showValidationErrorAlert(errorText: error.localizedDescription, textField: textField)
    }
    //カバービューの削除
    //keyboardWillHide(_ notification: Notification)でも同様の処理を行う
    removeCoverviews()
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
      
      textField.becomeFirstResponder()
      //テキストを空にする
      textField.text = ""
      //アラートを閉じる
      alert.dismiss(animated: true, completion: nil)
    }
    alert.addAction(okAction)
    
    self.present(alert, animated: true, completion: nil)
  }
  
  private func handleWeightTextFieldEditing(with results: Results<DateData>, text: String) {
    let realm = try! Realm()
    //空文字（"")でないかを確認
    if !text.isEmpty {
      //空文字でなかった場合
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
  }
  
  private func handleMemoTextFieldEditing(with results: Results<DateData>, text: String) {
    let realm = try! Realm()
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

