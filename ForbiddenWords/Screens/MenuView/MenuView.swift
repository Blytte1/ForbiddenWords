//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData



struct MenuView: View {
   @AppStorage("hasShownFirstScreen")  var dismissTutorial: Bool = false
   @Bindable private(set) var vm : MenuViewModel
   
   var body: some View {
      
      if dismissTutorial{
         VStack{
            LogoView()
               .padding(.vertical, 30)
            Spacer()
            VStack {
               HStack {
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
               Button{
                  withAnimation(.interactiveSpring(duration: 1.5)) {
                     dismissTutorial.toggle()
                  }
               }label: {
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
   let vm = MenuViewModel(game: GameManager(game: DummyData.game0,cardManager: CardManager(context:DataManager.shared.context)), router: GameRouter())
    
   NavigationStack {
      MenuView( vm: vm)
   }
}
struct RulesView: View {
   @Binding var dismissTutorial: Bool
   var body: some View {
      VStack (){
         Text("Regras de Forbidden Words")
            .fontWeight(.black)
            .customFont(size: 20)
            .padding(.bottom,10)
         ScrollView{
            
            VStack(alignment:.leading, spacing:10){
               HStack(spacing:5){
                  Image(systemName: "person.3")
                     .font(.title)
                  Text("Jogue com seus amigos:")
                     .padding(5)
                     .customFont(size: 20)
               }
               Text("São necessárias duas equipes com no mínimo 2 pessoas em cada.")
            }
            .padding(.horizontal,5)
            
            VStack(alignment:.leading, spacing:10){
               HStack(spacing:5){
                  Image(systemName: "checkmark.rectangle.fill")
                     .font(.title)
                     .foregroundStyle(.green)
                  Text("A rodada funciona assim:")
                     .padding(5)
                     .customFont(size: 20)
               }
               Text("O jogador da vez terá 60 segundos para fazer sua equipe acertar o máximo de palavras-chave possível. aperte a palavra-chave ou no ícone verde para pontuar surgir a próxima palavra-chave.")
            }
            .padding(.horizontal,5)
            
            VStack(alignment:.leading, spacing:10){
               HStack(spacing:5){
                  HStack {
                     Image(systemName: "arrow.trianglehead.2.clockwise")
                        .font(.title)
                  }
                  Text("Sem neurose!")
                     .customFont(size: 20)
                     .padding(5)
               }
               Text("Você pode trocar a carta 3 vezes sem perder pontos.")
            }
            .padding(.horizontal,5)
            .frame(maxWidth:.infinity,alignment: .leading)
            VStack(alignment:.leading, spacing:10){
               HStack(spacing:5){
                  Image(systemName: "xmark.rectangle.fill")
                     .font(.title)
                     .foregroundStyle(.red)
                  Text("O time oponente fiscaliza a rodada!")
                     .padding(5)
                     .customFont(size: 20)
               }
               Text("caso o time atual fale qualquer uma das palavras proíbidas, mesmo que parcialmente, o fiscal da rodada tocará no X e o ponto irá para o time oponente! Não vale gesticular ou apontar. Se desobedecer, o oponente pode pressionar o X sem dó.")
            }
            .padding(.horizontal, 5)
            VStack(alignment:.leading){
               HStack(spacing:5){
                  Image(systemName: "fireworks")
                     .font(.largeTitle)
                  Text("São apenas 5 rodadas!")
                     .customFont(size: 20)
               }
               Text("O time com mais pontos ao final de 5 rodadas será o vencedor. Boa Sorte!")
            }
            .padding(.vertical,5)
         }
         .padding(.horizontal,5)
         Button{
            withAnimation(.easeInOut(duration: 1)){
               dismissTutorial.toggle()
            }
         }label:{Text("Dispensar")}
            .buttonStyle(gameButtonStyle())
            .offset(y:20)
      }
      .font(.title2)
      .foregroundStyle(.orange)
      .padding()
      .background(.white)
   }
}

#Preview {
   @Previewable @State var dismissTutorial: Bool = true
   RulesView(dismissTutorial: $dismissTutorial)
}
