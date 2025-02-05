//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

struct TeamTurn: View {
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
            vm.router.navigateTo(GameScreen.round(vm.game))
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
      TeamTurn(vm: TeamTurnViewModel(game: DummyData.game0, router: GameRouter())
      )
   }
}
