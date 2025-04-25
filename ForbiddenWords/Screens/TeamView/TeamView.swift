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
            Section("Equipes"){
               ForEach(vm.gameManager.game.teams) { team in
                  HStack{
                     TextField(
                        "Digite o nome da equipe",
                        text: Binding(
                           get: { teamNames[team.id] ?? team.name }, // Obtém o valor temporário ou o nome original
                           set: { teamNames[team.id] = $0 } // Atualiza o valor temporário
                        )
                     )
                     .onSubmit {
                        if let newName = teamNames[team.id], !newName.isEmpty {
                           vm.changeTeamName(team: team, name: newName) // Salva o novo nome
                        }
                        titleIsChanging.toggle()
                     }
                     Button {
                        if let newName = teamNames[team.id], !newName.isEmpty {
                           vm.changeTeamName(team: team, name: newName) // Salva o novo nome
                        }
                        titleIsChanging.toggle()
                     } label: {
                        Image(systemName: "checkmark.square")
                     }
                  }
               }
               .foregroundStyle(.orange)
               .font(.title2)
               .fontWeight(.bold)
            }
             Section("Quantidade de Rounds"){
                 Picker("Número de Rounds", selection: $vm.gameManager.maxRoundNumbers) {
                     Text("3").tag(3)
                     Text("6").tag(6)
                     Text("9").tag(9)
                 }
                 .pickerStyle(SegmentedPickerStyle())
             }
             Section("Duração dos Rounds:"){
                 Picker("Número de Rounds", selection: $vm.duration) {
                     Text("60s").tag(60)
                     Text("90s").tag(90)
                     Text("120s").tag(120)
                 }
                 .pickerStyle(SegmentedPickerStyle())
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
