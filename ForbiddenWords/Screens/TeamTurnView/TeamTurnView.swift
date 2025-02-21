//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

struct TeamTurnView: View {
   @State var vm: TeamTurnViewModel
   
   var body: some View {
      VStack {
         Text("Agora é a vez do time:")
         Text(vm.currentTeam)
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            .padding()
         
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
   }
}

#Preview {
   
   NavigationStack{
      TeamTurnView(
         vm:TeamTurnViewModel(gameManager: GameManager(game: DummyData.game0),
            router: GameRouter())
      )
   }
}
