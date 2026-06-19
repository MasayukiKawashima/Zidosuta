//
//  UpdatesDisplayViewController.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/06/14.
//

import UIKit

struct UpdateItem: Hashable {

  let id: UUID
  let version: String
  let description: String
  let releaseDate: String
}

class UpdatesDisplayViewController: UIViewController {


  // MARK: - Properties

  let updateDisplayView = UpdatesDisplayView()
  private var dataSource: UITableViewDiffableDataSource<Section, UpdateItem>!

  let cellRowHeight: CGFloat = 60

  private let indicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.hidesWhenStopped = true
    indicator.color = .black
    return indicator
  }()


  // MARK: - Enums

  private enum Section {
    case main
  }

  // MARK: - LifeCycle

  override func loadView() {

    super.loadView()
    view = updateDisplayView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.

    view.addSubview(indicator)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])

    if UpdatesCache.needsRefresh() {

      // キャッシュが存在しない等で更新情報の取得が必要な場合
      indicator.startAnimating()

      Task {
        do {
          let result = try await fetchUpdates()
          UpdatesCache.save(result)
          configureDataSource()
          applyData(data: result.updates)

          indicator.stopAnimating()
        } catch {
          // エラーハンドリング
          print("エラー発生")
          showUpdatesFetchFailureAlert()
          indicator.stopAnimating()
        }
      }
    } else {
      // キャッシュがあった場合の処理
      if let cache = UpdatesCache.load() {
        print("有効なキャッシュが存在しました")
        configureDataSource()
        applyData(data: cache.updates)
      } else {
        // キャッシュが取得できなかったため再取得
        print("キャッシュの取得エラー")

        Task {
          do {
            let result = try await fetchUpdates()
            UpdatesCache.save(result)
            configureDataSource()
            applyData(data: result.updates)

            indicator.stopAnimating()
          } catch {
            // エラーハンドリング
            print("エラー発生")
            showUpdatesFetchFailureAlert()
            indicator.stopAnimating()
          }
        }
      }
    }
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


// MARK: - UITableViewDiffableDataSource周りの処理

extension UpdatesDisplayViewController {

  private func configureDataSource() {

    dataSource = UITableViewDiffableDataSource<Section, UpdateItem>(tableView: updateDisplayView.tableView, cellProvider: { tableView, indexPath, itemIdentifier in

      let cell = tableView.dequeueReusableCell(withIdentifier: self.updateDisplayView.cellIdentifier, for: indexPath) as! UpdatesDisplayTableViewCell

      cell.selectionStyle = UITableViewCell.SelectionStyle.none

      cell.versionLabel.text = itemIdentifier.version
      cell.releaseDateLabel.text = itemIdentifier.releaseDate
      cell.descriptionLabel.text = itemIdentifier.description
      cell.descriptionLabel.numberOfLines = 0
      cell.descriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
      return cell
    })
  }

  private func applyData(data: [ZidosutaUpdate]) {

    // テスト表示用データ
//    let testData = UpdateItem(id: UUID(), version: "v2.10.10", description: "アプリ内のデザインをリニューアルしました。\niOS26に対応しました。\n内部的な改善を行いました。", releaseDate: "2025.02.11")
//    let testData2 = UpdateItem(id: UUID(), version: "v0.0.0", description: "テストテストテストテスト", releaseDate: "2025.02.11")
//    let testData3 = UpdateItem(id: UUID(), version: "v0.0.0", description: "テストテストテストテスト", releaseDate: "2025.02.11")
//    let testData4 = UpdateItem(id: UUID(), version: "v0.0.0", description: "テストテストテストテスト", releaseDate: "2025.02.11")
//    let testData5 = UpdateItem(id: UUID(), version: "v0.0.0", description: "テストテストテストテスト", releaseDate: "2025.02.11")
//    let testData6 = UpdateItem(id: UUID(), version: "v0.0.0", description: "テストテストテストテスト", releaseDate: "2025.02.11")
//    let testData7 = UpdateItem(id: UUID(), version: "v0.0.0", description: "テストテストテストテスト", releaseDate: "2025.02.11")

    var snapshot = NSDiffableDataSourceSnapshot<Section, UpdateItem>()
    snapshot.appendSections([.main])

    for data in data {
      let displayDate = data.releaseDate.replacingOccurrences(of: "-", with: ".")
      let item = UpdateItem(id: UUID(), version: data.version, description: data.description, releaseDate: displayDate)
      snapshot.appendItems([item], toSection: .main)
    }
    dataSource.apply(snapshot, animatingDifferences: false)
  }

  private func fetchUpdates() async throws -> ZidosutaUpdatesResponse {

    let client = APIClient()
    let request = ZidosutaUpdatesRequest()

    return try await  client.request(request)
  }

  private func showUpdatesFetchFailureAlert() {

    let alert = UIAlertController(title: FetchUpdatesAlertString.FetchFailure.title, message: FetchUpdatesAlertString.FetchFailure.message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: FetchUpdatesAlertString.okActionTitle, style: .default) { action in
      self.navigationController?.popViewController(animated: true)
    }

    alert.addAction(okAction)
    present(alert, animated: true)
  }

}
