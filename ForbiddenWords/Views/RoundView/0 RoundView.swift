//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

struct RoundView: View {
   @State var vm: RoundViewModel
   @State private(set) var timeRemaining = 60
   
   var body: some View {
      VStack{
         VStack{
            Text("Round \(vm.game.currentRoundIndex)")
               .font(Font.custom("AttackOfMonsterRegular", size: 30))
            Text(vm.game.teams[vm.game.currentTeamIndex].name)
               .font(Font.custom("AttackOfMonsterRegular", size: 15))
         }
         .fontWeight(.bold)
         .foregroundStyle(.orange)
         ScoreBoard(game: vm.game, timeRemaining: $timeRemaining)
            .offset(y:-30)
            .padding()
         if !vm.showTeamList{
            CardView(card: vm.game.cards.first!)
               .scaleEffect(0.8, anchor: .center)
               .frame(height: 420)
               .offset(y:-20)
               .padding(.vertical, 10)
         }else{
            timeOverView
               .offset(y:-20)
               .padding(.vertical, 40)
         }
         buttonsView
         }
      .navigationBarBackButtonHidden(true)
      .toolbar(.hidden)
      .onChange(of: timeRemaining) { _, _ in
         if timeRemaining == 0 {
            withAnimation(.spring(duration:2) ){
               vm.showTeamList = true
            }
         }
      }
      .onChange(of: vm.game.cards[0].answerIsRight) { _, _ in
         Task{
            if let answer = vm.game.cards[0].answerIsRight{
               vm.dealCard(answer: answer)
            }
         }
      }
   }
}

#Preview{
   NavigationStack {
      RoundView(vm: RoundViewModel(game: Game(maxRoundNumbers: 3, teams: [DummyData.team, DummyData.team2], teamIndex: 0, roundIndex: 1, cards: DummyData.cards, rounds: [DummyData.round]), router: GameRouter())
      )
   }
}






