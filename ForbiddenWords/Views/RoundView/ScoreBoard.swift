//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

struct ScoreBoard: View {
   @State  var game: Game
   @Binding var timeRemaining: Int
   
   var body: some View {
      HStack {
         if !game.teams.isEmpty{
            VStack {
               Text(game.teams[0].name)
               Text("\(game.teams[0].cards.count)")
            }
            .scoreTextStyle()
            Spacer()
               CircularTimerView(timeRemaining: $timeRemaining)
                  .scaleEffect(0.50)
                  .frame(width:100,height: 150)
            Spacer()
            VStack {
               Text(game.teams[1].name)
               Text(game.teams[1].cards.count.description)
            }
            .scoreTextStyle()
         }
      }
      .padding(.horizontal,5)
   }
}
