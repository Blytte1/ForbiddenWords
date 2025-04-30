//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

struct TeamView: View {
  
   @State var vm: TeamViewModel
   @State private var name: String = ""
    let message = "Para começar o jogo, ao menos duas equipes, insira mais uma equipe."
    var body: some View {
      VStack{
          Text("Configure sua partida")
             .customFont(size: 30)
             .foregroundStyle(.orange)
             .multilineTextAlignment(.center)
             .padding(.bottom,30)
          TeamViewContent(vm: vm, name: $name)
              .toolbar{
                  ToolbarItem(placement: .topBarLeading) {
                      Button("Voltar"){
                          vm.router.popToRoot()
                      }                  }
                 ToolbarItem(placement: .bottomBar) {
                    if !vm.gameCheck() {
                       Text(message)
                          .foregroundStyle(.orange)
                          .customFont(size: 30)
                          .multilineTextAlignment(.center)
                    } else {
                       Button("Iniciar Partida") {
                          if vm.gameCheck() {
                              vm.startGame()
                             vm.router.navigateTo(.turn)
                          }
                       }
                       .buttonStyle(gameButtonStyle())
                    }
                 }
              }
      }
      .navigationBarBackButtonHidden()
      .foregroundStyle(.orange)
   }
}

#Preview ("Team View"){
    let context = DataManager.shared.context
    let vm = TeamViewModel(
        gameManager: GameManager(game: DummyData.game0, cardManager: CardManager(context:context)), router: GameRouter()
    )
   NavigationStack {
      TeamView(vm: vm)
   }
}

struct TeamViewContent: View {
   @State var vm: TeamViewModel
   @Binding var name: String
   @State var titleIsChanging = false
   @State var teamNames: [PersistentIdentifier: String] = [:]
  
   
   var body: some View {
      
       List {
           if vm.gameManager.game.teams.count < 2 {
               addTeam
           }
           Section("Renomeie as equipes"){
               ForEach(vm.gameManager.game.teams) { team in
                   HStack{
                       TextField(
                        "Digite o nome da equipe",
                        text: Binding(
                            get: { teamNames[team.id] ?? team.name }, // Obtém o valor temporário ou o nome original
                            set: { teamNames[team.id] = $0 }
                        )
                       )
                       .onSubmit {
                           if let newName = teamNames[team.id], !newName.isEmpty {
                               vm.changeTeamName(team: team, name: newName)
                           }
                           titleIsChanging.toggle()
                       }
                       .foregroundStyle(.orange)
                       .font(.title3)
                       Button ("Alterar"){
                           if let newName = teamNames[team.id], !newName.isEmpty {
                               vm.changeTeamName(team: team, name: newName)
                           }
                           titleIsChanging.toggle()
                       }
                       .buttonStyle(gameButtonStyle())
                       .scaleEffect(0.8)
                   }
                   .bold()
               }
           }
           Section("Defina a quantidade de rounds"){
               Picker("Número de Rounds", selection: $vm.gameManager.maxRoundNumbers) {
                   Text("3").tag(3)
                   Text("5").tag(5)
                   Text("7").tag(7)
               }
               .pickerStyle(.segmented)
           }
           Section("Duração dos rounds:"){
               Picker("Número de Rounds", selection: $vm.duration) {
                   Text("60s").tag(60)
                   Text("90s").tag(90)
                   Text("120s").tag(120)
               }
               .pickerStyle(.segmented)
           }
           Section("Escolha quantas trocas por round"){
               Picker("Quantidade de trocas", selection: $vm.gameManager.maxSkipCount) {
                   Text("3").tag(3)
                   Text("4").tag(4)
                   Text("5").tag(5)
               }
               .pickerStyle(.segmented)
           }
       }
         .listStyle(.insetGrouped)
         .listRowSeparator(.hidden)
         .listRowInsets(EdgeInsets())
         .scrollContentBackground(.hidden)
   }
}

extension TeamViewContent {
   var addTeam: some View {
      HStack {
         TextField(vm.gameManager.game.teams.count < 1 ? "Insira uma equipe" : "Insira mais uma equipe", text: $name)
            .onSubmit {
               vm.addTeam(name: name)
               name = ""
            }
         Button {
            vm.addTeam(name: name)
            name = ""
         } label: {
            Image(systemName: "person.2.badge.plus.fill")
         }
      }
      .background(.white)
      .cornerRadius(10)
      .foregroundStyle(.orange)
      .font(.title3)
      .bold()
   }
}
