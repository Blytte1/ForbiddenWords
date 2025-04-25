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
            .scaleEffect(1.5)
            .frame(height:400)
         Text( winnerText)
            .customFont(size: 50)
            .foregroundStyle(.orange)
            .task {
               winnerText =  vm.getWinner()
            }
            .offset(y:-50)
      Spacer()
         Button("tela inicial"){
            vm.resetGame()
         }
         .buttonStyle(gameButtonStyle())
         .scaleEffect(1.5)
         .task{
         SoundManager.shared.playSound(fileName: "gameOver", fileExtension: ".mp3")
         }
      }
      .navigationBarBackButtonHidden(true)
   }
}

//#Preview {
//   NavigationStack{
//      WinnerView(
//         vm: WinnerViewModel( gameManager:  GameManager(game: DummyData.game0, context: try! ModelContext(ModelContainer())), router: GameRouter()))
//   }
//}
