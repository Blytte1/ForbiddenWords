//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

struct WinnerView: View {
   @State private(set) var vm: WinnerViewModel
   @State private var winnerText: String = "Carregando..."
   var body: some View {
      VStack {
         LogoView()
            .scaleEffect(0.8)
         
         Text( winnerText)
            .font(Font.custom("AttackOfMonsterRegular", size: 50))
            .foregroundStyle(DummyData.shapeColor)
            .multilineTextAlignment(.center)
            .task {
               winnerText =  vm.getWinner()
            }
         Spacer()
         Button("Voltar a tela inicial"){
            Task{
              try await vm.gameManager.resetGame()
            }
            
            vm.router.popToRoot()
         }
         .buttonStyle(gameButtonStyle())
         .task{
            SoundManager.shared.playSound(fileName: "gameOver", fileExtension: ".mp3")
         }
      }
      .navigationBarBackButtonHidden(true)
   }
      
}

#Preview {
   NavigationStack{
      WinnerView(
         vm: WinnerViewModel( gameManager:  GameManager(game: DummyData.game0), router: GameRouter()))
   }
}
