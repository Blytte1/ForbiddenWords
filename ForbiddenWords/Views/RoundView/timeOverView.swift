//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI

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
            Text(vm.game.currentTeamIndex == 0 ? vm.game.teams[1].name : vm.game.teams[0].name )
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
