//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

struct WinnerView: View {
    @State private(set) var vm: WinnerViewModel
    var body: some View {
       VStack {
          LogoView()
             .scaleEffect(0.8)
             
       Text(vm.game.teamWithMostCards())
             .font(Font.custom("AttackOfMonsterRegular", size: 50))
             .foregroundStyle(DummyData.shapeColor)
             .multilineTextAlignment(.center)
          Spacer()
          Button("Voltar a tela inicial"){
             vm.game = DummyData.game0
             vm.router.popToRoot()
          }
          .buttonStyle(gameButtonStyle())
       }
       .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack{
        WinnerView(
         vm: WinnerViewModel( game: DummyData.game0, router: GameRouter()))
    }
}
