//
//  TopViewController.swift
//  Zidosuta
//
//  Created by 川島真之 on 2023/05/23.
//

import UIKit
import PhotosUI
import RealmSwift
import GoogleMobileAds

class TopViewController: UIViewController {

  // SwiftLinttest

  // MARK: - Properties

  private var topView = TopView()

  private var navigationBarCover: UIView?
  private var viewCover: UIView?
  private var tabBarCover: UIView?

  var topDateManager = TopDateManager()

  private var documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

  private let realm = try! Realm()

  private var notificationToken: NotificationToken?
  // 全データ削除後の更新処理のためプロパティ
  private var shouldReloadDataAfterDeletion: Bool = false
  // 初回レイアウトが完了しているかどうか
  // 全データ削除後のテーブルビューのリロードをするかどうかの分岐で使用する
  private var isViewFirstLayoutFinished = false

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    return .portrait
  }

  private var tabBarHeight: CGFloat {
    return tabBarController?.tabBar.frame.size.height ?? 49.0
  }
  private var navigationBarHeight: CGFloat {
    return self.navigationController?.navigationBar.frame.size.height ?? 44.0
  }
  private var statusBarHeight: CGFloat {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let statusBarFrame = windowScene.statusBarManager?.statusBarFrame {
      return statusBarFrame.height
    }
    return 0
  }
  // 各セルの高さの定義
  private var weightTableViewCellHeight: CGFloat = 70.0
  private var memoTableViewCellHeight: CGFloat = 47.0
  private var photoTableViewCellHeight: CGFloat {
    let totalHeight = view.frame.height
    let navigationHeight = navigationBarHeight
    let statusHeight = statusBarHeight
    let tabHeight = tabBarHeight
    let adHeight = adTableViewCellHeight

    return totalHeight - navigationHeight - statusHeight - tabHeight - weightTableViewCellHeight - memoTableViewCellHeight - adHeight
  }
  private var adTableViewCellHeight: CGFloat = 53.0

  // MARK: - Enums

  // セル周り設定用の列挙体
  enum TopPageCell: Int {
    case weightTableViewCell = 0
    case memoTableViewCell
    case photoTableViewCell
    case adTableViewCell
  }

  // テキストフィールドのタグの意味を示す列挙体
  enum TopPageTextFieldType: Int {
    case weight = 3
    case memo = 4
  }

  // MARK: - LifeCycle

  override func viewDidLoad() {

    super.viewDidLoad()

    topView.tableView.delegate = self
    topView.tableView.dataSource = self
    // キーボードの表示と非表示の監視
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    // スクロールできないようにする
    topView.tableView.isScrollEnabled = false
    // tableViewCellの高さの自動設定
    topView.tableView.estimatedRowHeight = UITableView.automaticDimension
    topView.tableView.rowHeight = UITableView.automaticDimension
    // セル間の区切り線を非表示
    topView.tableView.separatorStyle = .none

    setupRealmObserver()
  }

  // Realm内のDateDataの全データ削除後のTableViewのリロードを行うためのDateDataを監視のセットアップを行うメソッド
  private func setupRealmObserver() {
    
    let dateData = realm.objects(DateData.self)

    notificationToken = dateData.observe { changes in
      switch changes {
      case .update:
        //DateDataが空でありかつ、!self.shouldReloadDataAfterDeletionがtrue（shouldReloadDataAfterDeletioがfalseの場合にtrueとなる）であるということは
        //全てのDateDataが削除されたということなので、shouldReloadDataAfterDeletionをtrueにして、データ削除後のリロードが必要な状況であることを明示する
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
      // レイアウトが完了しているかどうか
      // この分岐をしないと、Viewのレイアウトが完了していない状態でtableView.reloadData()を実行してしまい
      // cellの高さを計算する時に不正な値が算出されてしまいアプリがクラッシュしてしまうことがある
      if isViewFirstLayoutFinished {
        // レイアウト更新後にリロードを実行
        self.topView.tableView.reloadData()
        self.shouldReloadDataAfterDeletion = false
      }
    }
  }

  override func loadView() {

    view = topView
  }

  override func viewDidLayoutSubviews() {

    super.viewDidLayoutSubviews()
    // 初回レイアウトが完了
    isViewFirstLayoutFinished = true
  }
}

// MARK: - UITableViewDelegate,UITableViewDataSource

// TableViewの設定
extension TopViewController: UITableViewDelegate, UITableViewDataSource {

  // TableViewのセクション内のセルの数
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return 4
  }

  func numberOfSections(in tableView: UITableView) -> Int {

    return 1
  }

  // 各セルを内容を設定し表示
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = TopPageCell(rawValue: indexPath.row)

    switch (cell)! {
    case .weightTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: "WeightTableViewCell", for: indexPath) as! WeightTableViewCell
      // セルの選択時のハイライトを非表示にする
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      cell.weightTextField.delegate = self
      cell.delegate = self

      let dateDataRealmSearcher = DateDataRealmSearcher()
      let results = dateDataRealmSearcher.searchForDateDataInRealm(currentDate: topDateManager.date)

      // 検索結果が0件か、該当するデータの体重が0の場合は""をセットする
      if results.isEmpty || results.first!.weight == 0 {
        cell.weightTextField.text = ""
      } else {
        let weightString = String(results.first!.weight)
        cell.weightTextField.text = weightString
      }

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

      return cell

    case .photoTableViewCell:
      let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as! PhotoTableViewCell
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      // 写真セルのデリゲート
      cell.delegate = self
      // テキストカラーをダークグレイに再設定
      // 写真読み込み時にテキストカラーが.redに変更されるため
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
        } else { // 画像ファイルの読み込みに失敗した時の処理
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
      // バナーIDの取得
      if let bannerID = fetchAdUnitID(key: "TopScreenBannerID") {
        cell.bannerView.adUnitID = bannerID
        let width = view.frame.size.width
        cell.bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width)
        cell.bannerView.rootViewController = self
        cell.bannerView.load(GADRequest())
      }

      return cell
    }
  }

  private func fetchAdUnitID(key: String) -> String? {

    guard let adUnitIDs = Bundle.main.object(forInfoDictionaryKey: "AdUnitIDs") as? [String: String] else {
        return nil
    }
    return adUnitIDs[key]
}

  // 各セルの高さの推定値を設定
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

  // セルの高さの設定
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

// MARK: - WeightTableViewCellDelegate, MemoTableViewCellDelegate

// エンターを押したらキーボードを閉じる処理
extension TopViewController: WeightTableViewCellDelegate, MemoTableViewCellDelegate {

  // notificationCenterのメソッド
  func weightTableViewCellDidRequestKeyboardDismiss(_ cell: WeightTableViewCell) {

    view.endEditing(true)
  }
  func memoTableViewCellDidRequestKeyboardDismiss(_ cell: MemoTableViewCell) {

    view.endEditing(true)
  }
}

// MARK: - PhotoTableViewCellDelegate, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate,UINavigationControllerDelegate

// 写真セル内のボタン押下時処理
extension TopViewController: PhotoTableViewCellDelegate, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate, UINavigationControllerDelegate {

  // 拡大ボタンが押された時の処理
  func expandButtonAction(photoImage: UIImage) {

    showPhotoModal(photoImage: photoImage)
  }
  // 削除ボタンが押された時の処理
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

  // 削除ボタンが押された時の確認のアラート
  private func deleteAlertAction(_ cell: PhotoTableViewCell) {

    let dateDataRealmSearcher = DateDataRealmSearcher()
    let results = dateDataRealmSearcher.searchForDateDataInRealm(currentDate: topDateManager.date)
    let resultsCount = results.count

    let realm = try! Realm()
    if resultsCount != 0 {
      if results.first!.photoFileURL != "" {
        // ドキュメント内の写真を削除する
        let documentPath = documentDirectoryFileURL.appendingPathComponent(results.first!.photoFileURL)
        do {
          try FileManager.default.removeItem(at: documentPath)
        } catch {
          print("ファイルの削除に失敗しました: \(error)")
        }
        // Realmからも写真パスと写真の方向データを削除する
        try! realm.write {
          results.first!.photoFileURL = ""
          results.first!.imageOrientationRawValue = Int()
        }
        // Viewから写真を削除し
        cell.photoImageView.image = nil
      }
    }
  }

  // 写真挿入ボタンとやり直しボタンを押した時の処理
  func insertButtonAction() {

    showPhotoSelectionActionSheet()
  }
  // 写真がダブルタップされた時の処理
  func photoDoubleTapAction(photoImage: UIImage) {

    showPhotoModal(photoImage: photoImage)
  }

  // モーダル表示するメソッド
  private func showPhotoModal(photoImage: UIImage) {

    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let photoModalVC = storyboard.instantiateViewController(withIdentifier: "PhotoModalVC") as? PhotoModalViewController {
      photoModalVC.modalPresentationStyle = .fullScreen
      photoModalVC.photoModalView.photoImageView.image = photoImage
      self.present(photoModalVC, animated: true, completion: nil)
    }
  }
  // カメラでキャンセルしたときのデリゲートメソッド
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

    picker.dismiss(animated: true, completion: nil)
  }

  // アクションシートの表示
  private func showPhotoSelectionActionSheet() {

    let actionSheet = UIAlertController(title: "写真の選択", message: nil, preferredStyle: .actionSheet)

    actionSheet.view.accessibilityIdentifier = "photoSelectionSheet"

    let cameraAction = UIAlertAction(title: "カメラ", style: .default) { action in
      // カメラ起動前にアクセス権限の状態を確認
      let status = AVCaptureDevice.authorizationStatus(for: .video)
      switch status {
        // 許可済み、未決定の場合
      case .authorized, .notDetermined:
        self.showImagePicker(sourceType: .camera)
        // 不許可の場合
      case .denied:
        self.showCameraPermissionAlert()
      case.restricted:
        // 制限の場合
        self.showCameraUnavailableAlert()
      @unknown default:
        return
      }
    }

    let photoLibraryAction = UIAlertAction(title: "フォトライブラリ", style: .default) { action in
      self.showPHPicker(sourceType: .images)
    }
    let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)

    actionSheet.addAction(cameraAction)
    actionSheet.addAction(photoLibraryAction)
    actionSheet.addAction(cancelAction)

    self.present(actionSheet, animated: true, completion: nil)
  }

  // ImagePickerControllerの表示
  private func showImagePicker(sourceType: UIImagePickerController.SourceType) {

    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
      let imagePicker = UIImagePickerController()
      imagePicker.sourceType = sourceType
      imagePicker.delegate = self
      self.present(imagePicker, animated: true, completion: nil)
    }
  }

  // PHPickerViewControllerの表示
  private func showPHPicker(sourceType: PHPickerFilter) {

    var configuration = PHPickerConfiguration()
    configuration.filter = sourceType
    configuration.selectionLimit = 1
    configuration.preferredAssetRepresentationMode = .current

    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = self
    self.present(picker, animated: true, completion: nil)
  }

  // UIImagePickerController内で画像を選択したときの処理
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

    if let pickedImage = info[.originalImage] as? UIImage {

      let imageInfo = createImageInfo()

      // 取得した写真の保存処理
      saveImageToDocument(pickedImage: pickedImage, path: imageInfo.path)

      // 現在のページの日付のRealmObjectが存在するか検索
      let dateDataRealmSearcher = DateDataRealmSearcher()
      let results = dateDataRealmSearcher.searchForDateDataInRealm(currentDate: topDateManager.date)

      handlePhotoStrorageAndRealm(results: results, pickedImage: pickedImage, imageInfo: imageInfo)
      // 取得した写真の表示処理
      // 現在表示されているPhotoTAbleViewCellのインスタンス取得
      let photoTableViewCell = topView.tableView.visibleCells[2] as! PhotoTableViewCell
      // 取得したインスタンスのimageに選択した写真を格納
      photoTableViewCell.photoImageView.image = pickedImage
    }
    // UIImagePickerControllerを閉じる
    picker.dismiss(animated: true, completion: nil)
  }

  // PHPickerViewController内でで画像を選択した際の処理
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

    if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
      itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
        guard let self = self,
              let pickedImage = image as? UIImage else { return }

        // UI更新とRealm操作はメインスレッドで実行
        DispatchQueue.main.async {
          let imageInfo = self.createImageInfo()
          self.saveImageToDocument(pickedImage: pickedImage, path: imageInfo.path)

          let dateDataRealmSearcher = DateDataRealmSearcher()
          let results = dateDataRealmSearcher.searchForDateDataInRealm(currentDate: self.topDateManager.date)

          self.handlePhotoStrorageAndRealm(results: results, pickedImage: pickedImage, imageInfo: imageInfo)

          // UI更新
          if let photoTableViewCell = self.topView.tableView.visibleCells[2] as? PhotoTableViewCell {
            photoTableViewCell.photoImageView.image = pickedImage
          }
          // 画像セット後にピッカーを閉じる
          picker.dismiss(animated: true)
        }
      }
    } else {
      // 画像が選択されなかった場合はそのままピッカーを閉じる
      picker.dismiss(animated: true)
    }
  }

  // ドキュメントディレクトリへ写真を保存するためのファイル名とフルパスを作成する処理
  private func createImageInfo() -> (fileName: String, path: URL) {

    let fileName = "\(NSUUID().uuidString)"
    // ファイル名
    let photoFileName = fileName
    // フルパス
    let path = documentDirectoryFileURL.appendingPathComponent(fileName)

    return (fileName: photoFileName, path: path)
  }

  // 写真選択後のドキュメントディレクトリとRealmのハンドリング
  private func handlePhotoStrorageAndRealm(results: Results<DateData>, pickedImage: UIImage, imageInfo: (fileName: String, path: URL)) {

    // 検索結果の件数を確認
    let resultsCount = results.count
    // 現在のページの日付のRealmObjectが存在するか確認
    if resultsCount != 0 {
      // 存在した場合
      // そのRealmObjectのphotoFileURLに古い写真のFileURLが登録されていたら
      if results.first!.photoFileURL != "" {
        // その古い写真を削除する
        let documentPath = documentDirectoryFileURL.appendingPathComponent(results.first!.photoFileURL)
        do {
          try FileManager.default.removeItem(at: documentPath)
        } catch {
          print("ファイルの削除に失敗しました: \(error)")
        }
      }
      try! realm.write {
        results.first!.photoFileURL = imageInfo.fileName
        results.first!.imageOrientationRawValue = pickedImage.imageOrientation.rawValue
      }
    }
    // 存在しなかった場合
    // 新しいRealObjectを現在のページの日付で登録
    let dateData = DateData()
    dateData.imageOrientationRawValue = pickedImage.imageOrientation.rawValue
    dateData.photoFileURL = imageInfo.fileName
    dateData.date = topDateManager.date
    try! realm.write {
      realm.add(dateData)
    }
  }

  // 写真をドキュメントに保存するメソッド
  private func saveImageToDocument(pickedImage: UIImage, path: URL) {

    let pngImageData = pickedImage.pngData()
    do {
      try pngImageData!.write(to: path)
    } catch {
      print("画像をドキュメントに保存できませんでした")
    }
  }

  // カメラへのアクセスを許可するよう促すアラート
  private func showCameraPermissionAlert() {

    let alert = UIAlertController(
      title: "カメラへのアクセスが許可されていません",
      message: "カメラを使用するには設定アプリからカメラへのアクセスを許可してください",
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }

  // カメラが使用できない旨のアラート
  private func showCameraUnavailableAlert() {

    let alert = UIAlertController(
      title: nil,
      message: "カメラは使用できません",
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}

// 各TextFieldのイベント処理
extension TopViewController: UITextFieldDelegate {

  // 各種カバービューを作成し配置
  private func createCoverViews() {

    addNavigationBarCover()
    addViewCover()
    addTabBarCover()
  }
  // カバービューを削除
  private func removeCoverviews() {

    navigationBarCover?.removeFromSuperview()
    navigationBarCover = nil

    viewCover?.removeFromSuperview()
    viewCover = nil

    tabBarCover?.removeFromSuperview()
    tabBarCover = nil
  }

  // 個別のカバービューの生成と配置
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

    // カバービューの生成と配置をする
    // textFieldDidBeginEditing(_ textField: UITextField)でも同様の処理を行う
    createCoverViews()
  }

  @objc private func keyboardWillHide(_ notification: Notification) {

    // カバービューの削除
    // textFieldDidEndEditingでも同様の処理を行う
    removeCoverviews()
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {

    // 各種カバービューがまだ生成されていなかったら、カバービューの生成と配置をする
    // カバービューの生成と配置自体はkeyboardWillShow(_ notification: Notification)でも行っている
    if navigationBarCover == nil && viewCover == nil && tabBarCover == nil {
      createCoverViews()
    }
  }

  // リターンが押されたとき
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {

    textField.resignFirstResponder()
    return true
  }

  // テキストフィールドの編集が終了した時
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
    // カバービューの削除
    // keyboardWillHide(_ notification: Notification)でも同様の処理を行う
    removeCoverviews()
  }

  // テキストフィールドのバリデート
  private func textFieldValidate(_ textField: UITextField) -> ValidationResult? {

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

  // バリデーションエラーのアラートを表示する
  private func showValidationErrorAlert(errorText: String, textField: UITextField) {

    let alert = UIAlertController(title: "", message: errorText, preferredStyle: .alert)

    let attributedTitle = NSAttributedString(string: "入力エラー", attributes: [
      .foregroundColor: UIColor.red,
      .font: UIFont.boldSystemFont(ofSize: 18) // ボールドフォント
    ])
    alert.setValue(attributedTitle, forKey: "attributedTitle")

    let okAction = UIAlertAction(title: "OK", style: .default) { _ in

      textField.becomeFirstResponder()
      // テキストを空にする
      textField.text = ""
      // アラートを閉じる
      alert.dismiss(animated: true, completion: nil)
    }
    alert.addAction(okAction)

    self.present(alert, animated: true, completion: nil)
  }

  private func handleWeightTextFieldEditing(with results: Results<DateData>, text: String) {

    let realm = try! Realm()
    // 空文字（"")でないかを確認
    if !text.isEmpty {
      // 空文字でなかった場合
      let weightDouble = Double(text)!
      // Realmのデータがあるかどうかで分岐
      if results.isEmpty {
        // データが無い場合
        let dateData = DateData()
        dateData.date = topDateManager.date
        dateData.weight = weightDouble
        try! realm.write {
          realm.add(dateData)
        }
        print("新しい体重データが作成されました")
      } else {
        // データがある場合
        try! realm.write {
          results[0].weight = weightDouble
          print("体重データを更新しました")
        }
      }
    } else {
      // 空文字でRealmのデータもない場合
      if results.isEmpty {
        print("体重データなし。体重が未入力です")
      } else {
        // Realmのデータはある場合
        // Realmのデータはあるのに、テキストフィールドを空にした　→ データを消去したいということ
        try! realm.write {
          results[0].weight = 0
          print("体重データを消去しました")
        }
      }
    }
  }

  private func handleMemoTextFieldEditing(with results: Results<DateData>, text: String) {

    let realm = try! Realm()
    // テキストが空文字じゃないかを確認
    if !text.isEmpty {
      // 空文字じゃなければ
      // Realmのデータがあるかを確認
      if results.isEmpty {
        // データがなければ
        let dateData = DateData()
        dateData.date = topDateManager.date
        dateData.memoText = text
        try! realm.write {
          realm.add(dateData)
        }
        print("新しいメモデータが作成されました")
      } else {
        // データあれば
        try! realm.write {
          results[0].memoText = text
          print("メモデータを更新しました")
        }
      }
    } else {
      // Realmのデータがない場合
      if results.isEmpty {
        print("メモデータなし。メモが未入力です")
      } else {
        // Realmのデータはある場合
        // Realmのデータはあるのに、テキストフィールドを空にした　→ データを消去したいということ
        try! realm.write {
          results[0].memoText = ""
          print("メモデータを消去しました")
        }
      }
    }
  }
}

// MARK: - GADBannerViewDelegate

extension TopViewController: GADBannerViewDelegate {

  // 広告のロードが成功して、表示準備が完了したときに呼ばれるデリゲートメソッド
  func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {

    if let cell = topView.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? AdTableViewCell {
      cell.placeholderView.isHidden = true
      cell.placeholderLogo.isHidden = true
    }
  }
}
