//
//  PhotoTipsView.swift
//  Zidosuta
//
//  Created by 川島真之 on 2025/06/02.
//

import SwiftUI

struct PhotoTipsView: View {
  
  
  // MARK: - Properties
  @StateObject private var model = OnboardingModel()
  
  
  // MARK: - Body
  
  var body: some View {
    NavigationView {
      GeometryReader { outerGeometry in
        ZStack {
          Color("YellowishRed")
            .ignoresSafeArea()
          ZStack {
            Color("OysterWhite")
            GeometryReader { geometry in
              
              VStack(alignment: .center) {
                Text("写真撮影のコツ")
                  .font(.custom("Thonburi-Bold", size: geometry.size.width * 0.08, relativeTo: .body))
                  .foregroundStyle(.black)
                  .minimumScaleFactor(0.5)
                  .padding(.top, 50)
                
                VStack {
                  Text(createAttributedString())
                    .font(.custom("Thonburi", size: geometry.size.width * 0.04, relativeTo: .body))
                  
                  Text("鏡越しの撮影や誰かに撮ってもらうのもオススメです")
                    .font(.custom("Thonburi", size: geometry.size.width * 0.04, relativeTo: .body))
                }
                .padding(.top, 5)
                .padding(.leading, 1)
                .padding(.trailing, 1)
                
                HStack(alignment: .top) {
                  VStack {
                    Image("WholeBody")
                      .resizable()
                      .scaledToFit()
                      .frame(width: geometry.size.width * 0.45)
                      .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    Image(systemName: "circle")
                      .foregroundStyle(.blue)
                      .font(.system(size: 40))
                      .padding(.top, 8)
                  }
                  .padding(.leading, 5)
                  .padding(.trailing, 5)
                  
                  VStack {
                    Image("HalfBody")
                      .resizable()
                      .scaledToFit()
                      .frame(width: geometry.size.width * 0.45)
                      .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    Image(systemName: "triangle")
                      .foregroundStyle(.red)
                      .font(.system(size: 40))
                      .padding(.top, 8)
                  }
                  .padding(.trailing, 5)
                }
                .padding(.top, 30)
                
                Spacer()
                
                HStack {
                  
                  
                  Button (action:  {
                    model.transitionToMainContent()
                    model.completeFirstLaunch()
                  },
                          label:  {
                    
                    Text("OK")
                      .font(.custom("Thonburi-Bold", size: geometry.size.width * 0.0533, relativeTo: .body))
                      .foregroundStyle(.white)
                      .padding(.horizontal, 50)
                      .padding(.vertical, 15)
                  })
                  .background(Color("YellowishRed"))
                  .cornerRadius(10)
                  .shadow(color: .gray.opacity(0.5), radius: 3, x: 2, y: 2)
                }
                .padding(.bottom, 30)
                .padding(.top, 10)
              }
              .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
          }
          .cornerRadius(10)
          .padding(.top, calculateVerticalMargin(for: outerGeometry.size))
          .padding(.bottom, calculateVerticalMargin(for: outerGeometry.size))
          .padding(.leading, 10)
          .padding(.trailing,10)
        }
      }
    }
  }
  
  
  // MARK: - Method
  
  //外側のYellowishRedの領域の高さの設定
  private func calculateVerticalMargin(for screenSize: CGSize) -> CGFloat {
    
    let screenHeight = screenSize.height
    
    let baseRatio: CGFloat = 0.050
    
    //許容される最小、最大の余白サイズ
    let minMargin: CGFloat = 10
    let maxMargin: CGFloat = 60
    
    let calculatedMargin = screenHeight * baseRatio
    
    //許容されるサイズと比較
    return max(minMargin, min(maxMargin, calculatedMargin))
  }
}

private func createAttributedString() -> AttributedString {
  
  var attributedString = AttributedString("全身が映るように撮ると変化が分かりやすくなります")
  
  if let range = attributedString.range(of: "全身が映るように撮る") {
    attributedString[range].foregroundColor = .red
  }
  return attributedString
}


// MARK: - Preview

#Preview {
  PhotoTipsView()
}
