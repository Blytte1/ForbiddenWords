//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

struct GalleryView: View {
   @Environment(\.modelContext) private var modelContext
   @State var vm: GalleryViewModel
   
   var body: some View {
      VStack {
         TabView {
            CardList(vm: $vm)
               .tabItem {
                  Image(systemName: "list.bullet.rectangle")
                  Text("Categorias")
                     .foregroundStyle(.orange)
               }
            CustomCardview(vm: vm)
               .tabItem {
                  VStack{ Image(systemName: "plus.app")
                     Text("Criar Carta")
                        .foregroundStyle(.orange)
                  }
               }
         }
      }
      .navigationBarBackButtonHidden(true)
      .toolbar{
         Button{vm.router.popToRoot()}label:{
            Image(systemName: "house.circle")
               .font(.largeTitle)
         }
      }
   }
}

#Preview {
   NavigationStack{
      GalleryView(vm: GalleryViewModel(router:GameRouter(), context: ModelContext(try! ModelContainer(for: Card.self))))
   }
}

struct CardList: View {
   @Binding var vm: GalleryViewModel
   var body: some View {
      VStack {
         HStack {
            Text("Escolha uma categoria:")
               .customFont(size: 30)
               .foregroundStyle(.orange)
         }
         VerticalPicker(selection:$vm.selectedCategory, options: vm.categories)
            .padding()
         List{
            ForEach(vm.filteredCards, id: \.keyWord) { card in
               NavigationLink(destination: CardView(card: card)) {
                  HStack{
                     Text(card.keyWord)
                        .customFont(size: 25)
                        .foregroundStyle(.orange)
                     Spacer()
                     Text(card.id.description)
                        .foregroundStyle(.orange)
                  }
               }
            }
         }
         .listStyle(.plain)
      }
   }
}

struct CustomCardview: View {
   
   @Bindable var vm: GalleryViewModel
   
   var isDisabled: Bool {if vm.newKeyword != "" && vm.newForbiddenWord1 != "" && vm.newForbiddenWord2 != "" && vm.newForbiddenWord3 != "" && vm.newForbiddenWord1 != "" && vm.newForbiddenWord4 != "" && vm.newForbiddenWord5 != "" {return false} else {return true}}
   
   var body: some View {
      ScrollView {
         Text("Crie sua carta")
            .foregroundStyle(.orange)
            .customFont(size: 30)
            .padding(.bottom,10)
         VStack {
            CardView(card: vm.newCard)
               .scaleEffect(0.6)
               .frame(width: 300, height: 330)
            ZStack {Rectangle()
                  .stroke(lineWidth: 5)
                  .cornerRadius(10)
               VStack(spacing:10){
                  Text("Palavra-chave")
                     .customFont(size: 15)
                  TextField( "Digite uma palavra-chave", text: $vm.newKeyword)
                  Text("Palavras proibidas")
                     .customFont(size: 15)
                  TextField( "Digite a palavra proibida 1", text: $vm.newForbiddenWord1)
                  TextField( "Digite a palavra proibida 2", text: $vm.newForbiddenWord2)
                  TextField( "Digite a palavra proibida 3", text: $vm.newForbiddenWord3)
                  TextField( "Digite a palavra proibida 4", text: $vm.newForbiddenWord4)
                  TextField( "Digite a palavra proibida 5", text: $vm.newForbiddenWord5)
               }
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth:.infinity, alignment: .center)
            .foregroundStyle(.orange)
         }
         .padding(.horizontal, 70)
         Button{
            vm.createCard()}label: {
               Text("Gerar")
            }
            .buttonStyle(gameButtonStyle(fillColor: isDisabled ? .gray.opacity(0.4): .orange))
            .disabled(isDisabled)
      }
   }
}
#Preview ("CardCustomView"){
   @Previewable @State var vm = GalleryViewModel(router:  GameRouter(), context: ModelContext(try! ModelContainer(for: Card.self)))
   CustomCardview(vm: vm)
}

