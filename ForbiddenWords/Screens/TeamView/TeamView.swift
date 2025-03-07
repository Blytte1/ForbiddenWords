//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

struct TeamView: View {
   @Environment(\.modelContext) var context
   @State var vm: TeamViewModel
   @State private var name: String = ""
   
   var body: some View {
      TeamViewContent(
         vm: vm,
         name: $name
      )
   }
}

//#Preview ("Team View"){
//   NavigationStack {
//      TeamView(
//         vm:TeamViewModel(gameManager: GameManager(game: DummyData.game0, context: context), router: GameRouter())
//      )
//   }
//}

struct TeamViewContent: View {
   @State var vm: TeamViewModel
   @Binding var name: String
   @State var titleIsChanging = false
   @State var teamNames: [PersistentIdentifier: String] = [:] // Dicionário para armazenar os valores temporários
   let message = "Para começar o jogo, ao menos duas equipes, insira mais uma equipe."
   
   var body: some View {
      Spacer()
      Text("Altere o nome das equipes ou inicie apartida")
         .customFont(size: 30)
         .foregroundStyle(.orange)
         .multilineTextAlignment(.center)
      if vm.gameManager.game.teams.count < 2 {
         addTeam
            .padding(20)
      }
      List {
         ForEach(vm.gameManager.game.teams) { team in
            HStack {
               if !titleIsChanging {
                  Text(team.name)
                     .customFont(size: 30)
                     .onTapGesture {
                        titleIsChanging.toggle()
                     }
                     .foregroundStyle(.orange)
                     .font(.title3)
                     .bold()
                     .onAppear {
                        teamNames.updateValue(team.name, forKey: team.id) // Inicializa o valor temporário
                     }
                  Spacer()
                  Button {
                     vm.removeTeam(team: team)
                  } label: {
                     Image(systemName: "person.2.badge.minus.fill")
                        .foregroundStyle(.red)
                  }
               } else {
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
         }
         .foregroundStyle(.orange)
         .font(.title2)
         .fontWeight(.bold)
      }
      .navigationBarBackButtonHidden(true)
      .onAppear {
         let appearance = UINavigationBarAppearance()
         appearance.configureWithTransparentBackground()
         appearance.titleTextAttributes = [.foregroundColor: UIColor.orange]
         appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.orange]
         UINavigationBar.appearance().standardAppearance = appearance
         UINavigationBar.appearance().scrollEdgeAppearance = appearance
      }
      
      if !vm.gameCheck() {
         Text(message)
            .foregroundStyle(.orange)
            .customFont(size: 30)
            .offset(y:-300)
            .multilineTextAlignment(.center)
         
      } else {
         Button("Iniciar Partida") {
            if vm.gameCheck() {
               vm.StartGame()
               vm.router.navigateTo(.turn)
            }
         }
         .offset(y: 20)
         .buttonStyle(gameButtonStyle())
      }
      
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
