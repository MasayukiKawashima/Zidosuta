//
//  NotificationSettingViewControllerWrapper.swift
//  Zidosuta
//
//  Created by 川島真之 on 2024/12/31.
//

import SwiftUI

struct NotificationSettingViewControllerWrapper: UIViewControllerRepresentable {

  // MARK: - Properties

  @Binding var isPresented: Bool

  // MARK: - Methods

  func makeCoordinator() -> Coordinator {

    Coordinator(self)
  }

  func makeUIViewController(context: Context) -> NotificationSettingViewController {

    let viewController = NotificationSettingViewController()
    viewController.transitionSource = .swiftUI
    viewController.dismissCallback = {
      context.coordinator.dismiss()
    }
    return viewController
  }

  func updateUIViewController(_ uiViewController: NotificationSettingViewController, context: Context) {

  }

  class Coordinator: NSObject {

    var parent: NotificationSettingViewControllerWrapper

    init(_ parent: NotificationSettingViewControllerWrapper) {

      self.parent = parent
    }

    @objc func dismiss() {

      parent.isPresented = false
    }
  }
}
