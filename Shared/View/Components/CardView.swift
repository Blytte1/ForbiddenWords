//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import Observation

struct CardView: View {
   @Bindable  var card: Card
   var body: some View {
      
      ZStack {
         CardBackgroundView()
         VStack(alignment: .center) {
            KeyWordView(card: card)
            ForbiddenWordsView(card: card)
         }
         .frame (width: 350, height: 450)
         .padding(.vertical,10)
         .background(.white.opacity(0.8))
         .cornerRadius(30)
         .padding(20)
      }
   }
}
#Preview {
   @Previewable @State var card: Card = DummyData.uncategorizedCards[0]
   CardView(card: card)
}
struct KeyWordView: View{
   @Bindable var card: Card
   var  body: some View {
      VStack() {
         Text("A palavra é:")
            .font(.title3)
            .foregroundStyle(.orange)
            .fontWeight(.heavy)
            .shadow(color:.white, radius: 10)
            .padding(5)
         Button{
            self.card.answerIsRight = true
         }label: {
            Text(card.keyWord)
               .cardTextStyle()
         }
         .background(.orange)
         .shadow(color:.orange, radius: 100)
         .cornerRadius(10)
         .padding(.horizontal)
      }
   }
}

struct ForbiddenWordsView: View{
   @Bindable var card: Card
   var body: some View{
      VStack {
         Text("Palavras Proibidas:")
            .font(.title3)
            .foregroundStyle(.orange)
            .fontWeight(.heavy)
            .shadow(color:.white, radius: 10)
         ForEach(card.forbiddenWords, id: \.self) { word in
            Button {
               self.card.answerIsRight = false
            }label: {
               Text(word)
                  .cardTextStyle()
            }
            .background(.orange)
            .shadow(color:.orange, radius: 100)
            .cornerRadius(10)
            .padding(.horizontal)
         }
      }
   }
}



struct CardBackgroundView: View{
   var body: some View {
      ZStack {
         Color.orange
            .cornerRadius(40)
            .offset(y: 1)
         LinearGradient(
            colors: [.orange,
                     .white.opacity(0.5),
                     .orange],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
         )
      }
      .frame (width: 370, height: 500)
      .cornerRadius(40)
   }
}
struct CardBackView: View{
   var body: some View {
      
      VStack(alignment: .center) {
         LogoView()
      }
      .frame (width: 370, height: 500)
      .background{
         CardBackgroundView()
      }
      .cornerRadius(40)
   }
}
#Preview("CardBackView"){
   CardBackView()
}


