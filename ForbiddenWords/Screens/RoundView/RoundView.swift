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
            Text("Round \(vm.gameManager.currentRoundIndex)")
               .font(Font.custom("AttackOfMonsterRegular", size: 30))
            Text(vm.gameManager.game.teams[vm.gameManager.currentTeamIndex].name)
               .font(Font.custom("AttackOfMonsterRegular", size: 15))
         }
         .fontWeight(.bold)
         .foregroundStyle(.orange)
         ScoreBoard(game: vm.gameManager.game, timeRemaining: $timeRemaining)
            .offset(y:-30)
            .padding()
         if !vm.showTeamList{
            CardView(card: vm.gameManager.game.cards.first!)
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
      .onChange(of: vm.gameManager.game.cards[0].answerIsRight) { _, _ in
         Task{
            if let answer = vm.gameManager.game.cards[0].answerIsRight{
               await vm.dealCard(answer: answer)
            }
         }
      }
   }
}

//MARK: - BUTTONSVIEW

extension RoundView{
   var buttonsView: some View {
      
      HStack (spacing:30){
         if timeRemaining > 0{
            // Equipe concede cartas
            Button{
               SoundManager.shared.playSound(fileName: "errou", fileExtension: ".mp3")
               vm.concedeCards()
            }label:{
               Image(systemName: "xmark")
                  .padding(5)
            }
            .buttonStyle(gameButtonStyle(fillColor:.red))
            
            //equipe pula cartas
            Button{
               SoundManager.shared.playSound(fileName: "pular", fileExtension: ".mp3")
               vm.skipCard()
            }label:{
               HStack {
                  Image(systemName: "arrow.trianglehead.2.clockwise")
                  ZStack{
                     Image(systemName: "lanyardcard")
                     Text("\(3 - vm.skipCount)")
                  }
               }
            }
            .buttonStyle(gameButtonStyle(fillColor: vm.skipCount < 3 ? .orange : .gray))
            .disabled(vm.buttonIsDisabled)
            //Equipe ganha cartas
            Button{
               SoundManager.shared.playSound(fileName: "certaResposta", fileExtension: ".mp3")
               vm.winCards()
            }label:{
               Image(systemName: "checkmark")
                  .padding(5)
            }
            .buttonStyle(gameButtonStyle(fillColor: .green))
         }
         
         else {
            Button{
               vm.isGameOver()
            }label:{
               HStack{
                  Image(systemName: "arrow.trianglehead.2.clockwise")
                  Image(systemName: "person.3.fill")
               }
            }
            .buttonStyle(gameButtonStyle())
         }
      }
   }
}

//MARK: - SCOREBOARD

private struct ScoreBoard: View {
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

//MARK: - TIMEOVERVIEW
extension RoundView {
   var timeOverView: some View {
      VStack{
         Text("O tempo acabou!".uppercased())
            .frame(maxWidth:280)
            .background(.white)
            .cornerRadius(5)
            .padding(5)
         VStack {
            Text("Próximo Time:")
            Text(vm.gameManager.currentTeamIndex == 0 ? vm.gameManager.game.teams[1].name : vm.gameManager.game.teams[0].name )
         }
         .frame(maxWidth:280)
         .background(.white)
         .cornerRadius(5)
         .padding(5)
      }
      .cardTextStyle(textColor: Color.orange)
      .frame(width: 350,height: 350, alignment: .center)
      .background{
         CardBackView()
            .scaleEffect(0.8, anchor: .center)
            .frame(height: 420)
         
      }
   }
}

// MARK: - PREVIEW
#Preview{
   NavigationStack {
      RoundView(vm: RoundViewModel(gameManager: GameManager(game: DummyData.game0), router: GameRouter())
      )
   }
}






