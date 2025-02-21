//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData



struct MenuView: View {
   
   @State private(set) var vm : MenuViewModel
   
   var body: some View {
      
      VStack{
        
         LogoView()
            .padding(.vertical, 30)
         Spacer()
         
         HStack{
            Button{
               vm.router.navigateTo(.team)
            }label: {
               Text("Jogar")
                  .frame(maxWidth: 150)
            }
            .cornerRadius(20)
            Button{
               vm.router.navigateTo(.gallery)
            }label: {
               Text("Galeria")
                  .frame(maxWidth: 150)
            }
            .cornerRadius(20)
         }
         .buttonStyle(gameButtonStyle())
      }
      .frame(maxWidth: .infinity).ignoresSafeArea()
      .padding()

   }
}
#Preview {

   NavigationStack {
      MenuView(
         vm: MenuViewModel(game: GameManager(game: DummyData.game0), router: GameRouter())
      )
   }
}
