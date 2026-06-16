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
    updateDisplayView.tableView.rowHeight = cellRowHeight

    configureDataSource()
    applyData()
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
      return cell
    })
  }

  private func applyData() {

    // テスト表示用データ
    let testData = UpdateItem(id: UUID(), version: "v0.0.0", description: "テストテストテストテスト", releaseDate: "2025-02-11")
    let testData2 = UpdateItem(id: UUID(), version: "v0.0.0", description: "テストテストテストテスト", releaseDate: "2025-02-11")
    let testData3 = UpdateItem(id: UUID(), version: "v0.0.0", description: "テストテストテストテスト", releaseDate: "2025-02-11")
    let testData4 = UpdateItem(id: UUID(), version: "v0.0.0", description: "テストテストテストテスト", releaseDate: "2025-02-11")
    let testData5 = UpdateItem(id: UUID(), version: "v0.0.0", description: "テストテストテストテスト", releaseDate: "2025-02-11")
    let testData6 = UpdateItem(id: UUID(), version: "v0.0.0", description: "テストテストテストテスト", releaseDate: "2025-02-11")
    let testData7 = UpdateItem(id: UUID(), version: "v0.0.0", description: "テストテストテストテスト", releaseDate: "2025-02-11")

    var snapshot = NSDiffableDataSourceSnapshot<Section, UpdateItem>()
    snapshot.appendSections([.main])
    snapshot.appendItems([testData, testData2, testData3, testData4, testData5, testData6, testData7], toSection: .main)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
