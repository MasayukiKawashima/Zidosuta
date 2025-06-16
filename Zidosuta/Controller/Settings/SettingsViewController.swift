//
//  SettingsViewController.swift
//  Zidosuta
//
//  Created by 川島真之 on 2023/05/23.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {

  // MARK: - Properties

  private var settingsView = SettingsView()

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    .portrait
  }

  private var TableViewCellHeight: CGFloat = 60.0

  private let contactEmailAdress = "info.zidosuta@gmail.com"

  // MARK: - Enums

  enum SettingPageCell: Int {
    case notificationTableViewCell = 0
    case deleteDataTableViewCell
    case termsOfUseTableViewCell
    case privacyPolicyTableViewCell

    var values: (section: Int, row: Int) {
      switch self {
      case .notificationTableViewCell:
        return (section: 0, row: 0)
      case .deleteDataTableViewCell:
        return (section: 0, row: 1)
      case .termsOfUseTableViewCell:
        return (section: 1, row: 0)
      case .privacyPolicyTableViewCell:
        return (section: 1, row: 1)
      }
    }
  }

  enum SettingPageCells: Int, CaseIterable {
    case notificationTableViewCell
    case deleteDataTableViewCell
    case termsOfUseTableViewCell
    case privacyPolicyTableViewCell
    case contactTableViewCell

    var sectionNumber: Int {
      switch self {
      case .notificationTableViewCell, .deleteDataTableViewCell:
        return 0
      case .termsOfUseTableViewCell, .privacyPolicyTableViewCell, .contactTableViewCell:
        return 1
      }
    }

    var identifier: String {
      switch self {
      case .notificationTableViewCell:
        return "NotificationTableViewCell"
      case .deleteDataTableViewCell:
        return "DeleteDataTableViewCell"
      case .termsOfUseTableViewCell:
        return "TermsOfUseTableViewCell"
      case .privacyPolicyTableViewCell:
        return "PrivacyPolicyTableViewCell"
      case .contactTableViewCell:
        return "ContactTableViewCell"
      }
    }

    // セクションごとのケースを返すメソッド
    static func cases(forSection section: Int) -> [SettingPageCells] {

      return SettingPageCells.allCases.filter {$0.sectionNumber == section}
    }
  }

  // MARK: - LifeCycle

  override func viewDidLoad() {

    super.viewDidLoad()

    // Do any additional setup after loading the view.
    settingsView.tableView.delegate = self
    settingsView.tableView.dataSource = self

    // セルの区切り線を左端まで伸ばす
    settingsView.tableView.separatorInset = UIEdgeInsets.zero
    // navigationBarのタイトルの設定
    //      settingsView.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Thonburi-Bold", size: 20)!]
    // スクロールできないようにする
    settingsView.tableView.isScrollEnabled = false
    // セルの高さの自動設定
    settingsView.tableView.rowHeight = UITableView.automaticDimension

    navigationBarTittleSettings()
  }

  override func loadView() {

    super.loadView()
    view = settingsView
  }

  override func viewWillAppear(_ animated: Bool) {

    super.viewWillAppear(animated)

    DispatchQueue.main.async {
      let section = SettingPageCell.notificationTableViewCell.values.section
      let row = SettingPageCell.notificationTableViewCell.values.row
      let indexPath = IndexPath(row: row, section: section)
      self.settingsView.tableView.reloadRows(at: [indexPath], with: .none)
    }
  }
}

// MARK: - UITableViewDelegate,UITableViewDataSource

// tableViewの設定
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {

    return 2
  }

  // セル数の設定
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    switch section {
    case 0:
      return 2
    case 1:
      return 3
    default:
      return 0
    }
  }

  // 各セルの内容の設定
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    // 現在設定しているセクションのセルを取得
    let sectionCells = SettingPageCells.cases(forSection: indexPath.section)
    // 現在設定している行に対応するセルを取得
    let cellType = sectionCells[indexPath.row]
    // セルを生成（キャスト前）
    let preCastCell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath)

    // セルの種類によって処理の分岐
    switch cellType {
    case .notificationTableViewCell:
      let  cell = preCastCell as! NotificationTableViewCell
      let isNotificationEnabled = Settings.shared.notification?.isNotificationEnabled
      // 通知機能が有効かどうかで分岐
      if isNotificationEnabled! {
        // 通知機能が有効な場合
        // statusLabelに記録されている時間を表示する
        let setDate = Settings.shared.notification?.notificationTime
        let combinedString = setDate?.convertDateToNotificationTimeString()
        cell.statusLabel.text = combinedString
        cell.statusLabel.textColor = .YellowishRed
        // スイッチをオンにする
        cell.notificationSwitch.isOn = true
      } else {
        // 通知機能が無効な場合
        // statusLabelにオフと表示し
        cell.statusLabel.text = "オフ"
        // テキストカラーをlightGrayにし
        cell.statusLabel.textColor = .lightGray
        // スイッチをオフにする
        cell.notificationSwitch.isOn = false
      }

      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      cell.delegate = self
      return cell

    case .deleteDataTableViewCell:
      let cell = preCastCell as! DeleteDataTableViewCell
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      cell.delegate = self
      return cell

    case .termsOfUseTableViewCell:
      let cell = preCastCell as! TermsOfUseTableViewCell
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      cell.delegate = self
      return cell

    case .privacyPolicyTableViewCell:
      let cell = preCastCell as! PrivacyPolicyTableViewCell
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      cell.delegate = self
      return cell

    case .contactTableViewCell:
      let cell = preCastCell as! ContactTableViewCell
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      cell.delegate = self
      return cell
    }
  }

  // セルの高さの推定値の設定
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

    return TableViewCellHeight
  }
  // セルの高さを設定
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    return TableViewCellHeight
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

    let footerView = UIView()
    footerView.backgroundColor = .clear

    if section == 0 {
      return footerView
    }
    return nil
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

    if section == 0 {
      return 25
    } else if section == 1 {
      return UITableView.automaticDimension
    }
    return 0
  }

}

// MARK: - NavigationBarTittleSetting

extension SettingsViewController {

  private func navigationBarTittleSettings() {

    let titleText = "設定"
    let customTitleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))

    let titleTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 22))
    titleTextLabel.text = titleText
    titleTextLabel.font = UIFont(name: "Thonburi-Bold", size: 18.0)
    titleTextLabel.textColor = .black
    titleTextLabel.sizeToFit()

    titleTextLabel.translatesAutoresizingMaskIntoConstraints = false

    customTitleView.addSubview(titleTextLabel)

    NSLayoutConstraint.activate([
      titleTextLabel.centerXAnchor.constraint(equalTo: customTitleView.centerXAnchor),
      titleTextLabel.centerYAnchor.constraint(equalTo: customTitleView.centerYAnchor)
    ])
    self.navigationItem.titleView = customTitleView
  }
}

// MARK: - NotificationTableViewCellDelegate

extension SettingsViewController: NotificationTableViewCellDelegate {

  func switchAction(isOn: Bool) {

    let row = SettingPageCell.notificationTableViewCell.values.row
    let section = SettingPageCell.notificationTableViewCell.values.section
    guard let cell = settingsView.tableView.cellForRow(at: IndexPath(row: row, section: section)) as? NotificationTableViewCell else { return }
    // スイッチをオンにしたら
    if isOn {
      let storyBoard = UIStoryboard(name: "Main", bundle: nil)
      guard let notificationSettingViewController = storyBoard.instantiateViewController(withIdentifier: "NotificationSetting") as? NotificationSettingViewController else { return }
      self.navigationController?.pushViewController(notificationSettingViewController, animated: true)
      // 一秒間遅延させる
      // 遅延させないと画面遷移アニメーション中にstatusLabelが.yellowishRedになっていることが見えてしまう
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        cell.statusLabel.textColor = .YellowishRed
      }
      // オフにしたら
    } else {
      // スイッチオフを記録
      let settings = Settings.shared
      settings.update { settings in
        settings.notification?.isNotificationEnabled = false
      }
      // 通知スケジュールの削除
      let center = UNUserNotificationCenter.current()
      center.getPendingNotificationRequests { requests in
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
      }
      // statuLabelの編集
      cell.statusLabel.text = "オフ"
      cell.statusLabel.textColor = .lightGray
    }
  }
}

// MARK: - DeleteDataTableViewCellDelegate

extension SettingsViewController: DeleteDataTableViewCellDelegate {

  func transitionButtonAction() {

    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    guard let notificationSettingViewController = storyBoard.instantiateViewController(withIdentifier: "DataDeletionExecution") as? DataDeletionExecutionViewController else { return }
    self.navigationController?.pushViewController(notificationSettingViewController, animated: true)
  }
}

// MARK: - TermsOfUseTableViewCellDelegate, PrivacyPolicyTableViewCellDelegate

extension SettingsViewController: TermsOfUseTableViewCellDelegate, PrivacyPolicyTableViewCellDelegate {

  func TermsOfUseTransitionButtonAction() {

    let termsDisplayViewController = initTermsDisplayViewController()
    termsDisplayViewController.termsType = .termsOfUse
    navigationController?.pushViewController(termsDisplayViewController, animated: true)
  }

  func privacyPolicyTransitionButtonAction() {

    let termsDisplayViewController = initTermsDisplayViewController()
    termsDisplayViewController.termsType = .privacyPolicy
    navigationController?.pushViewController(termsDisplayViewController, animated: true)
  }

  func initTermsDisplayViewController() -> TermsDisplayViewController {

    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let termsDisplayViewController = storyBoard.instantiateViewController(withIdentifier: "TermsDisplay") as! TermsDisplayViewController
    return termsDisplayViewController
  }
}

// MARK: - MFMailComposeViewControllerDelegate, ContactTableViewCellDelegate

extension SettingsViewController: MFMailComposeViewControllerDelegate, ContactTableViewCellDelegate {

  func mailingButtonAction() {

    // メーリング機能が使えるかどうかチェック
    if MFMailComposeViewController.canSendMail() {
      // 使えるなら
      let mail = MFMailComposeViewController()
      mail.mailComposeDelegate = self
      mail.setToRecipients([contactEmailAdress])
      present(mail, animated: true, completion: nil)
    } else {
      // 使えないなら
      showEmailUnavailableAlert()
    }
  }

  // メールの送信後に呼ばれるデリゲートメソッド
  // 送信の成功、失敗によって異なるアラートを表示
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: (any Error)?) {

    controller.dismiss(animated: true)

    if result == .sent {
      showEmailSendSuccessAlert()
    } else if result == .failed {
      showEmailSendfailureAlert()
    }
  }

  private func showEmailSendfailureAlert() {

    let alert = UIAlertController(title: "メール機能が使えません", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }

  private func showEmailSendSuccessAlert() {

    let alert = UIAlertController(title: "メールを送信しました", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }

  private func showEmailUnavailableAlert() {

    let alert = UIAlertController(title: "メールを送信できませんでした", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}
