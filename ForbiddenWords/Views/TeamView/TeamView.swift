//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

struct TeamView: View {
   @State var vm: TeamViewModel
   @State private var name: String = ""
   
   var body: some View {
      TeamViewContent(
         vm: vm,
         name: $name
      )
   }
}

#Preview ("Team View"){
   NavigationStack {
      TeamView(
         vm:TeamViewModel(game: DummyData.game0, router: GameRouter())
      )
   }
}

struct TeamViewContent: View {
   @State var vm: TeamViewModel
   @Binding var name: String
   @State var titleIsChanging = false
   @State var teamNames: [PersistentIdentifier: String] = [:] // Dicionário para armazenar os valores temporários
   let message = "Para começar o jogo, adicione pelo menos duas equipes"
   
   var body: some View {
      List {
         if vm.game.teams.count < 2 {
            addTeam
         }
         ForEach(vm.game.teams) { team in
            HStack {
               if !titleIsChanging {
                  Text(team.name)
                     .font(Font.custom("AttackOfMonsterRegular", size: 30))
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
      .scrollContentBackground(.hidden)
      .navigationTitle("Configure sua equipe")
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
            .font(.title3)
            .multilineTextAlignment(.center)
            .background(.black)
      } else {
         Button("Iniciar Partida") {
            if vm.gameCheck() {
               vm.StartGame()
               vm.router.navigateTo(.turn(vm.game))
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
         TextField(vm.game.teams.count < 1 ? "Insira uma equipe" : "Insira mais uma equipe", text: $name)
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
