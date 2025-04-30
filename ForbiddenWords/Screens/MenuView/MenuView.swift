//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData


struct MenuView: View {
   @AppStorage("hasShownFirstScreen") var dismissTutorial: Bool = false
   @Bindable private(set) var vm: MenuViewModel
   
   var body: some View {
      
      if dismissTutorial {
         VStack {
            LogoView()
               .padding(.vertical, 30)
            Spacer()
            VStack {
               HStack {
                  Button {
                     vm.router.navigateTo(.team)
                  } label: {
                     Text("Jogar")
                        .frame(maxWidth: 150)
                  }
                  .cornerRadius(20)
                  Button {
                     vm.router.navigateTo(.gallery)
                  } label: {
                     Text("Galeria")
                        .frame(maxWidth: 150)
                  }
                  .cornerRadius(20)
               }
               .buttonStyle(gameButtonStyle())
               Button {
                  withAnimation(.interactiveSpring(duration: 1.5)) {
                     dismissTutorial.toggle()
                  }
               } label: {
                  Text("Rever Regras")
               }
               .padding(.top)
            }
         }
         .frame(maxWidth: .infinity).ignoresSafeArea()
         .padding()
      } else {
         RulesView(dismissTutorial: $dismissTutorial)
      }
   }
}

#Preview {
   let vm = MenuViewModel(game: GameManager(game: DummyData.game0, cardManager: CardManager(context: DataManager.shared.context)), router: GameRouter())
    
   NavigationStack {
      MenuView(vm: vm)
   }
}

struct RulesView: View {
   @Binding var dismissTutorial: Bool
   var body: some View {
      VStack {
         Text("Regras de Forbidden Words")
            .fontWeight(.black)
            .customFont(size: 20)
            .padding(.bottom, 10)
         ScrollView {
            
            VStack(alignment: .leading, spacing: 10) {
               HStack(spacing: 5) {
                  Image(systemName: "person.3")
                     .font(.title)
                  Text("Jogue com seus amigos:")
                     .padding(5)
                     .customFont(size: 20)
               }
               Text("Para jogar, são necessárias duas equipes de no mínimo 2 pessoas.")
            }
            .padding(.horizontal, 5)
            
            VStack(alignment: .leading, spacing: 10) {
               HStack(spacing: 5) {
                  Image(systemName: "checkmark.rectangle.fill")
                     .font(.title)
                     .foregroundStyle(.green)
                  Text("O jogo funciona assim:")
                     .padding(5)
                     .customFont(size: 20)
               }
               Text("O jogador da vez terá entre 60 e 120 segundos para fazer sua equipe acertar o máximo de palavras-chave possível, sem falar nenhuma das palavras proibidas. Quando o time acertar, aperte a palavra-chave ou no ícone verde para pontuar e surgir a próxima palavra-chave.")
            }
            .padding(.horizontal, 5)
            
            VStack(alignment: .leading, spacing: 10) {
               HStack(spacing: 5) {
                  HStack {
                     Image(systemName: "arrow.trianglehead.2.clockwise")
                        .font(.title)
                  }
                  Text("Sem neurose!")
                     .customFont(size: 20)
                     .padding(5)
               }
               Text("Caso não conheça a palavra-chave, o jogador poderá trocar a carta atual por outra, sem perder pontos.")
            }
            .padding(.horizontal, 5)
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading, spacing: 10) {
               HStack(spacing: 5) {
                  Image(systemName: "xmark.rectangle.fill")
                     .font(.title)
                     .foregroundStyle(.red)
                  Text("O time oponente fiscaliza o round!")
                     .padding(5)
                     .customFont(size: 20)
               }
               Text("Se o jogador atual falar qualquer uma das palavras proibidas, mesmo que parcialmente, o fiscal do round tocará na palavra-chave ou no botão vermelho \"X\" e o ponto irá para o time oponente! Não vale gesticular ou apontar. Se desobedecer, o fiscal pode pressionar o \"X\" sem dó.")
            }
            .padding(.horizontal, 5)
            VStack(alignment: .leading) {
               HStack(spacing: 5) {
                  Image(systemName: "fireworks")
                     .font(.largeTitle)
                  Text("Atenção para o Round!")
                     .customFont(size: 20)
               }
               Text("O time com mais pontos ao final do número máximo de rounds definido inicialmente será o vencedor. Boa sorte!")
            }
            .padding(.vertical, 5)
         }
         .padding(.horizontal, 5)
         Button {
            withAnimation(.easeInOut(duration: 1)) {
               dismissTutorial.toggle()
            }
         } label: { Text("Dispensar") }
            .buttonStyle(gameButtonStyle())
            .offset(y: 20)
      }
      .font(.title2)
      .foregroundStyle(.orange)
      .padding()
      .background(.white)
   }
}

#Preview("Tutorial") {
   @Previewable @State var dismissTutorial: Bool = true
   RulesView(dismissTutorial: $dismissTutorial)
}
