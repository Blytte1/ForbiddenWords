//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import Foundation
import SwiftUI

struct LogoView: View {
   var body: some View {
      VStack (spacing:1){
         ZStack{
            Circle()
               .stroke(lineWidth: 30)
               .fill(DummyData.shapeColor)
               .frame(width: 250, height: 250)
            Text("W")
               .font(Font.custom("AttackOfMonsterRegular", size: 240))
               .multilineTextAlignment(.center)
               .foregroundStyle(DummyData.letterColor)
               .offset(x:-10)
               .shadow(color:.black, radius: 8, x:5, y:10)
            Rectangle()
               .fill(.orange)
               .cornerRadius(10)
               .rotationEffect(Angle(degrees: 45))
               .frame(width: 280, height: 25)
         }
         .frame(width: 250)
         .padding(.vertical,30)
         Text("FORBIDDEN WORDS")
            .font(Font.custom("AttackOfMonsterRegular", size: 60))
            .multilineTextAlignment(.center)
            .foregroundStyle(DummyData.shapeColor)
            .shadow(color:.black, radius: 8, x:5, y:10)
      }
   }
}
#Preview{
   LogoView()
}

