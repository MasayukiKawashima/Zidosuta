//
//  PhotoTipsView.swift
//  Zidosuta
//
//  Created by 川島真之 on 2025/06/02.
//

import SwiftUI

struct PhotoTipsView: View {
  
  
  // MARK: - Body
  
    var body: some View {
      ZStack {
        Color("OysterWhite")
          .ignoresSafeArea()
        GeometryReader { geometry in
          VStack(alignment: .center) {
            Text("写真撮影のコツ")
              .font(.custom("Thonburi", size: geometry.size.width * 0.08, relativeTo: .body))
              .foregroundColor(Color(UIColor.YellowishRed))
              .minimumScaleFactor(0.5)
            
            Text("全身が映るように撮ると、変化が分かりやすくなります。")
              .font(.custom("Thonburi", size: geometry.size.width * 0.035, relativeTo: .body))
            
            Text("鏡越しの撮影や誰かに撮ってもらうのもオススメです。")
              .font(.custom("Thonburi", size: geometry.size.width * 0.035, relativeTo: .body))
            
            HStack {
              Image("WholeBody")
                .resizable()
                .scaledToFit()
              Image("HalfBody")
                .resizable()
                .scaledToFit()
            }
            
            HStack {
              Image(systemName: "circle")
                .foregroundStyle(.red)
              Image(systemName: "triangle")
                .foregroundStyle(.blue)
            }
            
            Button (action:  {
              //ボタン押下時の処理
            },
                    label:  {
              
              Text("OK")
                .font(.custom("Thonburi-Bold", size: geometry.size.width * 0.0533, relativeTo: .body))
                .foregroundStyle(.white)
            })
            .background(Color("YellowishRed"))
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.5), radius: 3, x: 2, y: 2)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
    }
}

#Preview {
    PhotoTipsView()
}
