//
//  TermsTextView.swift
//  Zidosuta
//
//  Created by 川島真之 on 2025/01/06.
//

import SwiftUI

struct TermsTextView: View {

  // MARK: - Properties

  @Binding var showTermsDisplay: Bool
  @Binding var selectedTermsType: TermsDisplayViewController.TermsType?

  let fontSize: CGFloat

  // MARK: - Body

  var body: some View {
    VStack {
      Text(makeAttributedString())
        .font(.custom("Thonburi", size: fontSize, relativeTo: .body))
        .multilineTextAlignment(.center)
        .environment(\.openURL, OpenURLAction { url in
          if url.scheme == "terms" {
            selectedTermsType = .termsOfUse
            showTermsDisplay = true
          } else if url.scheme == "privacy" {
            selectedTermsType = .privacyPolicy
            showTermsDisplay = true
          }
          return .handled
        })

      NavigationLink(isActive: $showTermsDisplay) {
        if let termsType = selectedTermsType {
          TermsDisplayViewControllerWrapper(termsType: termsType)
            .navigationBarTitleDisplayMode(.inline)
        }
      } label: {
        EmptyView()
      }
    }
    .padding(.horizontal, 10)
  }

  // MARK: - Methods

  private func makeAttributedString() -> AttributedString {

    var text = AttributedString("利用規約とプライバシーポリシーをご確認頂き、ご同意の上アプリをご利用下さい")
    text.foregroundColor = .darkGray

    // 利用規約の部分にスタイルを適用
    if let range = text.range(of: "利用規約") {

      text[range].foregroundColor = .blue
      text[range].underlineStyle = .single
      text[range].link = URL(string: "terms://tap")
    }

    // プライバシーポリシーの部分にスタイルを適用
    if let range = text.range(of: "プライバシーポリシー") {
      text[range].foregroundColor = .blue
      text[range].underlineStyle = .single
      text[range].link = URL(string: "privacy://tap")
    }
    return text
  }
}
