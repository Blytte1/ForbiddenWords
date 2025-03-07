//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

struct TeamTurnView: View {
   @State var vm: TeamTurnViewModel
   
   var body: some View {
      VStack {
         Spacer()
         Text("Agora é a vez da equipe:")
            .customFont(size: 30)
         Text(vm.currentTeam)
            .multilineTextAlignment(.center)
            .customFont(size: 45)
         
         LogoView()
         Spacer()
         Button{
            vm.router.navigateTo(GameScreen.round)
         } label: {
            Text("Ok")
               .frame(width:200)
         }
         .buttonStyle(gameButtonStyle())
         Spacer()
      }
      .foregroundStyle(.orange)
      .frame(maxWidth:.infinity,maxHeight: .infinity)
      .navigationBarBackButtonHidden(true)
      .padding()
   }
}

#Preview {
   
   NavigationStack{
      TeamTurnView(
         vm:TeamTurnViewModel(gameManager: GameManager(game: Game(
            teams: [Team(name: "Equipe 1", cards: []),Team(name: "Equipe 2", cards: [])],
            cards: [],
            rounds: [Round(RoundNumber: 1)]
         ), cardManager: CardManager(context: ModelContext(try! ModelContainer(for: Card.self)))),
                              router: GameRouter())
      )
   }
}
