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
            .padding(.top, 60)
          
          VStack {
            Text("全身が映るように撮ると、変化が分かりやすくなります。")
              .font(.custom("Thonburi", size: geometry.size.width * 0.035, relativeTo: .body))
            
            Text("鏡越しの撮影や誰かに撮ってもらうのもオススメです。")
              .font(.custom("Thonburi", size: geometry.size.width * 0.035, relativeTo: .body))
          }
          .padding(.top, 5)
          
          HStack(alignment: .top) {
            VStack {
              Image("WholeBody")
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width * 0.45)
              
              Image(systemName: "circle")
                .foregroundStyle(.red)
                .font(.system(size: 40))
                .padding(.top, 10)
            }
            .padding(.leading, 5)
            .padding(.trailing, 5)
            
            VStack {
              Image("HalfBody")
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width * 0.45)
              
              Image(systemName: "triangle")
                .foregroundStyle(.blue)
                .font(.system(size: 40))
                .padding(.top, 10)
            }
            .padding(.trailing, 5)
          }
          .padding(.top, 60)
          
          Spacer()
          
          HStack {
            Button("もどる") {
              //ボタン押下時の処理
            }
            .frame(width: 80, height: 40)
            .foregroundStyle(.gray)
            .padding(.leading, 20)
            
            Spacer()
            
            Button (action:  {
              //ボタン押下時の処理
            },
                    label:  {
              
              Text("OK")
                .font(.custom("Thonburi-Bold", size: geometry.size.width * 0.0533, relativeTo: .body))
                .foregroundStyle(.white)
                .padding(.horizontal, 50)
                .padding(.vertical, 12)
            })
            .background(Color("YellowishRed"))
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.5), radius: 3, x: 2, y: 2)
            
            Spacer()
         
            Color.clear
             .frame(width: 80, height: 40)
             .padding(.trailing, 20)

          }
          .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
}

#Preview {
  PhotoTipsView()
}
