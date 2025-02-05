//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

extension RoundView{
   var buttonsView: some View {
      
      HStack (spacing:30){
         if timeRemaining > 0{
            // Equipe concede cartas
            Button{
               vm.concedeCards()
            }label:{
               Image(systemName: "xmark")
                  .padding(5)
            }
            .buttonStyle(gameButtonStyle(fillColor:.red))
            
            //equipe pula cartas
            Button{
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
