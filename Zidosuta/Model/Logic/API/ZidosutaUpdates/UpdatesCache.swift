//
//  UpdatesCache.swift
//  Zidosuta
//
//  Created by 川島真之 on 2026/06/19.
//

import Foundation

enum UpdateInfoCache {
    private static let key = "cachedUpdates"

    // 現在のアプリバージョン（Info.plist の CFBundleShortVersionString）。
    // static let なので一度だけ初期化される不変の定数。
    static let currentAppVersion: String =
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"

    // キャッシュ読み込み。なければ nil。
    static func load() -> ZidosutaUpdatesResponse? {

        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(ZidosutaUpdatesResponse.self, from: data)
    }

    // キャッシュ保存。
    static func save(_ response: ZidosutaUpdatesResponse) {

        guard let data = try? JSONEncoder().encode(response) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    // 再取得が必要か。
    // 「最新の version が現在のアプリバージョンと一致するときのみスキップ」、
    // それ以外（初回・空・アップデート後など）は取得する。
    static func needsRefresh() -> Bool {

      // キャッシュが存在しないか、またはキャッシュの中身が0件だった場合はtrue(つまり、更新情報を取得しないといけない)
        guard let cached = load(),
              let latest = cached.updates.first else { return true }
        return currentAppVersion.compare(latest.version, options: .numeric) != .orderedSame
    }
}
