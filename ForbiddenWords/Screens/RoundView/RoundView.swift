//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

struct RoundView: View {
   @State var vm: RoundViewModel
   
   var body: some View {
      VStack{
         if !vm.showTeamList && !vm.gameManager.game.cards.isEmpty{
            VStack{
               Text("Round \(vm.gameManager.currentRoundId)")
                  .customFont(size: 30)
               Text(vm.gameManager.game.teams[vm.gameManager.currentTeamIndex].name)
                  .customFont(size: 20)
            }
            .fontWeight(.bold)
            .foregroundStyle(.orange)
            ScoreBoard(game: vm.gameManager.game, timeRemaining: $vm.timeRemaining)
               .offset(y:-30)
               .padding()
            CardView(card: vm.gameManager.game.cards.first ?? Card(id: 0, keyWord: "teste", forbiddenWords: ["String", "Strong", "Stretch","Struch"]))
               .scaleEffect(0.8, anchor: .center)
               .frame(height: 420)
               .offset(y:-20)
               .padding(.vertical, 10)
         }else{
            Spacer()
            TimeOverView(vm: $vm)
         }
         Spacer()
         BottomButtonsView(vm: $vm)
      }
      .navigationBarBackButtonHidden(true)
      .toolbar{
         Button{
            vm.router.popToRoot()
            Task {
               try! await vm.gameManager.resetGame()
            }
         }label:{
            Image(systemName: "house.circle")
               .font(.largeTitle)
         }
      }
      .onChange(of: vm.timeRemaining) { _, _ in
         if vm.timeRemaining == 0 {
            withAnimation(.spring(duration:2) ){
               vm.showTeamList = true
            }
         }
      }
      
      .onChange(of: vm.gameManager.game.cards[0].answerIsRight) { _, _ in
         Task{
            if let answer = vm.gameManager.game.cards[0].answerIsRight{
               await vm.dealCard(answer: answer)
            }
         }
      }
   }
}

//MARK: -   Circular Timer View

@MainActor
struct CircularTimerView: View {
   @Binding var timeRemaining: Int
   @State private var timerRunning = false
   let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
   let totalDuration: TimeInterval = 60
   
   var body: some View {
      VStack{
         ZStack {
            Circle()
               .stroke(Color.gray.opacity(0.3), lineWidth: 10)
            Arc(endAngle: .degrees(Double(progress) * 360 - 90))
               .stroke(Color.orange, style: StrokeStyle(lineWidth: 10, lineCap: .round))
            
            Text("\(timeRemaining)")
               .customFont(size: 50)
               .foregroundColor(.gray)
         }
         Button{timerRunning.toggle()}label: {
            Image(systemName: timerRunning ? "playpause.fill" : "play.fill")
               .font(.largeTitle)
               .foregroundStyle(.orange)
         }
         .offset(y:30)
         .multilineTextAlignment(.center)
      }
      .frame(width: 200, height: 200)
      .onReceive(timer) { _ in
         guard timerRunning else { return }
         if timeRemaining > 0 {
            withAnimation(.easeIn) {
               timeRemaining -= 1
            }
         } else {
            timerRunning = false
         }
      }
      .onAppear {
         timeRemaining = 60
         timerRunning = true
      }
      .onDisappear {
         timerRunning = false
      }
   }
   var progress: Double {
      Double(totalDuration - Double(timeRemaining)) / totalDuration
   }
}

struct Arc: Shape {
   var endAngle: Angle
   
   func path(in rect: CGRect) -> Path {
      let center = CGPoint(x: rect.midX, y: rect.midY)
      let radius = min(rect.width, rect.height) / 2
      let startAngle = Angle.degrees(-90)
      
      var path = Path()
      path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
      return path
   }
}

//MARK: - BUTTONSVIEW

struct BottomButtonsView: View{
   @Binding var vm: RoundViewModel
   var body: some View {
      
      HStack (spacing:30){
         if vm.timeRemaining > 0{
            // Equipe concede cartas
            Button{
               Task{
                  await vm.dealCard(answer: false)
               }
            }label:{
               Image(systemName: "xmark")
                  .padding(5)
            }
            .buttonStyle(gameButtonStyle(fillColor:.red))
            
            //equipe pula cartas
            Button{
               withAnimation(.easeInOut) {
                  vm.skipCard()
               }
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
            Button{
               Task{
                  await vm.dealCard(answer: true)
               }
            }label:{
               Image(systemName: "checkmark")
                  .padding(5)
            }
            .buttonStyle(gameButtonStyle(fillColor: .green))
         }
      }
   }
}

//MARK: - SCOREBOARD

private struct ScoreBoard: View {
   @State  var game: Game
   @Binding var timeRemaining: Int
   
   var body: some View {
      HStack {
         if !game.teams.isEmpty{
            VStack {
               Text(game.teams[0].name)
               Text("\(game.teams[0].cards.count)")
            }
            .scoreTextStyle()
            Spacer()
            CircularTimerView(timeRemaining: $timeRemaining)
               .scaleEffect(0.50)
               .frame(width:100,height: 150)
            Spacer()
            VStack {
               Text(game.teams[1].name)
               Text(game.teams[1].cards.count.description)
            }
            .scoreTextStyle()
         }
      }
      .padding(.horizontal,5)
   }
}

//MARK: - TIMEOVERVIEW
private struct TimeOverView: View{
   @Binding var vm: RoundViewModel
   var body: some View {
      VStack{
         Text("O tempo acabou!".uppercased())
            .frame(maxWidth:280)
            .cornerRadius(5)
            .padding(.horizontal,5)
         Spacer()
         VStack {
            Text("Próxima Equipe:")
            Text(vm.gameManager.currentTeamIndex == 0 ? vm.gameManager.game.teams[1].name : vm.gameManager.game.teams[0].name )
               .padding(.vertical,2)
         }
         .frame(maxWidth:280)
         .cornerRadius(5)
         .multilineTextAlignment(.center)
         .offset(y:38)
         .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
               vm.isGameOver()
            }
         }
      }
      .cardTextStyle(textColor: Color.white)
      .frame(width: 350,height: 350, alignment: .center)
      .background{
         CardBackView()
            .scaleEffect(0.8, anchor: .center)
            .frame(height: 420)
      }
   }
}


// MARK: - PREVIEW
#Preview{
   NavigationStack {
      RoundView(vm: RoundViewModel(gameManager: GameManager(game: Game( teams: [DummyData.team, DummyData.team2], cards: DummyData.uncategorizedCards, rounds: [DummyData.round]), cardManager: CardManager(context: ModelContext(try! ModelContainer(for: Card.self)))), router: GameRouter())
      )
   }
}






