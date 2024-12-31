//
//  OnBoardView.swift
//  DietApp
//
//  Created by 川島真之 on 2024/12/26.
//

import SwiftUI

struct OnBoardView: View {
  
  init() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(named: "YellowishRed")
    // タイトルの色を白に設定
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    // 戻るボタンの文字色を白に設定
    appearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
    
    // バックボタンの画像の色を白に設定
    let backIndicatorImage = UIImage(systemName: "chevron.backward")?
      .withTintColor(.white, renderingMode: .alwaysOriginal)
    appearance.setBackIndicatorImage(backIndicatorImage, transitionMaskImage: backIndicatorImage)
    
    // NavigationBarの設定を適用
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
    
    // NavigationBarの tintColor を白に設定
    UINavigationBar.appearance().tintColor = .white
  }
  
  @State private var showingNotificationSetting = false
  
  var body: some View {
    NavigationView {
      ZStack {
        Color("YellowishRed")
          .ignoresSafeArea()
        GeometryReader { geometry in
          VStack(alignment: .center, spacing: 20) {
            Image("LongWideLogo")
              .resizable()
              .scaledToFit()
              .frame(width: geometry.size.width * 0.75)
              .padding(.top, 20)
            
            VStack(alignment: .center, spacing: 20) {
              Text("Welcome!")
                .font(.custom("Futura-Bold", size: geometry.size.width * 0.096, relativeTo: .body))
                .scaledToFit()
                .minimumScaleFactor(0.5)
              
              Text("記録忘れ防止に便利な通知機能をご活用ください。")
                .font(.custom("Thonburi", size: geometry.size.width * 0.035, relativeTo: .body))
                .foregroundColor(Color(UIColor.darkGray))
                .padding(.horizontal, 5)
                .scaledToFit()
                .minimumScaleFactor(0.5)
              
              NavigationLink(
                isActive: $showingNotificationSetting,
                destination: {
                  NotificationSettingViewControllerWrapper(isPresented: $showingNotificationSetting)
                  
                },
                label: {
                  Label("通知を登録する", systemImage: "timer")
                    .font(.custom("Thonburi-Bold", size: geometry.size.width * 0.03733, relativeTo: .body))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                }
              )
              .background(Color("YellowishRed"))
              .cornerRadius(10)
              .shadow(color: .gray.opacity(0.5), radius: 3, x: 2, y: 2)
              
              Text(makeAttributedString())
                .environment(\.openURL, OpenURLAction { url in
                  if url.scheme == "action" {
                    switch url.host {
                    case "terms":
                      print("利用規約がタップされました")
                    case "privacy":
                      print("プライバシーポリシーがタップされました")
                    default:
                      break
                    }
                    return .handled
                  }
                  return .systemAction
                })
                .padding(.horizontal, 10)
                .font(.custom("Thonburi", size: geometry.size.width * 0.032, relativeTo: .body))
                .minimumScaleFactor(0.5)
                .lineLimit(2)
                .font(.body)
              
              Button(
                action: {
                  transitionToMainContent()
                  UserDefaults.standard.set(true, forKey: "didCompleteFirstLaunch")
                },
                label: {
                  Text("始める")
                    .font(.custom("Thonburi-Bold", size: geometry.size.width * 0.0533, relativeTo: .body))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 100)
                    .padding(.vertical, 10)
                }
              )
              .background(Color("YellowishRed"))
              .cornerRadius(10)
              .shadow(color: .gray.opacity(0.5), radius: 3, x: 2, y: 2)
            }
            .frame(width: geometry.size.width - 30, height: geometry.size.height / 2)
            .background(
              Rectangle()
                .fill(Color("OysterWhite"))
                .frame(width: geometry.size.width - 40, height: geometry.size.height / 2)
                .cornerRadius(10)
                .padding(.top, 10)
                .padding(.bottom, 10)
            )
          }
          .frame(width: geometry.size.width, height: geometry.size.height)
          .position(x:geometry.size.width / 2, y: geometry.size.height / 2)
          .dynamicTypeSize(DynamicTypeSize.small...DynamicTypeSize.xLarge)
        }
      }
      .navigationBarHidden(true)
      .accentColor(.white)
    }
  }
  
  private func makeAttributedString() -> AttributedString {
    var attributedString = AttributedString("利用規約とプライバシーポリシーをご確認の上、ご同意いただける場合は本アプリの利用を開始してください。")
    attributedString.foregroundColor = .darkGray
    
    if let termsRange = attributedString.range(of: "利用規約") {
      attributedString[termsRange].foregroundColor = .blue
      attributedString[termsRange].underlineStyle = .single
      attributedString[termsRange].link = URL(string: "action://terms")
    }
    
    if let privacyRange = attributedString.range(of: "プライバシーポリシー") {
      attributedString[privacyRange].foregroundColor = .blue
      attributedString[privacyRange].underlineStyle = .single
      attributedString[privacyRange].link = URL(string: "action://privacy")
    }
    
    return attributedString
  }
  
  private func transitionToMainContent() {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first {
      let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
      if let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
        window.rootViewController = tabBarController
        
        let snapshot = UIScreen.main.snapshotView(afterScreenUpdates: true)
        window.addSubview(snapshot)
        UIView.animate(withDuration: 0.5, animations: {
          snapshot.alpha = 0
        }, completion: { _ in
          snapshot.removeFromSuperview()
        })
      }
    }
  }
}

#Preview {
  OnBoardView()
}
