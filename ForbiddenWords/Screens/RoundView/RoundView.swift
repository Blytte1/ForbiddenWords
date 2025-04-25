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
                    Text(vm.gameManager.currentRoundId != vm.gameManager.maxRoundNumbers ? "Round \(vm.gameManager.currentRoundId) " : "Último Round")
                        .customFont(size: 30)
                    Text(vm.gameManager.game.teams[vm.gameManager.currentTeamIndex].name)
                        .customFont(size: 20)
                }
                .fontWeight(.bold)
                .foregroundStyle(.orange)
                .offset(y:-30)
                
                ScoreBoard(vm: vm)
                    .offset(y:-30)
                
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
            ToolbarItem(placement: .topBarTrailing) {
                HStack{
                    Button{
                        vm.router.popToRoot()
                        vm.gameManager.resetGame()
                    }label:{
                        Image(systemName: "house.circle")
                            .font(.title)
                    }
                    Button{
                        vm.gameManager.soundOn.toggle()
                        vm.soundOn = vm.gameManager.soundOn
                    }label:{
                        Image(systemName: vm.gameManager.soundOn ? "speaker.circle" : "speaker.slash.circle")
                            .font(.title)
                            .foregroundStyle(vm.gameManager.soundOn ? .accent : .gray)
                    }
                }
                ignoresSafeArea()
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
    @Binding var vm: RoundViewModel
    @State private var timerRunning = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let totalDuration: TimeInterval = 60
    
    var body: some View {
        VStack(spacing:10) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.orange, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .animation(.easeInOut, value: progress) // Adiciona animação ao progresso
                    .rotationEffect(Angle(degrees: -90)) // Rotaciona para começar do topo
                
                Text("\(vm.timeRemaining)")
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
            }
            Button(action: { timerRunning.toggle() }) {
                ZStack {
                    Image(systemName: timerRunning ? "pause.fill" : "play.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .onReceive(timer) { _ in
            guard timerRunning else { return }
            if vm.timeRemaining > 0 {
                withAnimation(.easeIn) {
                    vm.timeRemaining -= 1
                }
            } else {
                timerRunning = false
            }
        }
        .onAppear {
            vm.timeRemaining = vm.defaultTimerSetting
            timerRunning = true
        }
        .onDisappear {
            timerRunning = false
        }
    }
    
    var progress: Double {
        Double(totalDuration - Double(vm.timeRemaining)) / totalDuration
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
                        .font(.largeTitle)
                        .padding(5)
                }
                .buttonStyle(gameButtonStyle(fillColor:.red))
                
                //equipe pula cartas
                Button{
                    withAnimation(.easeInOut) {
                        vm.skipCard()
                    }
                }label:{
                    ZStack {
                        Image(systemName: "arrow.trianglehead.2.clockwise")
                            .font(.largeTitle)
                        Text("\(3 - vm.skipCount)")
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
                        .font(.title)
                        .padding(5)
                }
                .buttonStyle(gameButtonStyle(fillColor: .green))
            }
        }
    }
}

//MARK: - SCOREBOARD

private struct ScoreBoard: View {
    @State  var vm: RoundViewModel
    
    var body: some View {
        HStack {
            if !vm.gameManager.game.teams.isEmpty{
                VStack {
                    Text(vm.gameManager.game.teams[0].name)
                        .padding(.bottom)
                    Text("\(vm.gameManager.game.teams[0].cards.count)")
                }
                .scoreTextStyle()
                .frame(width: 150, height: 150)
                CircularTimerView(vm: $vm)
                
                VStack {
                    Text(vm.gameManager.game.teams[1].name)
                        .padding(.bottom)
                    Text(vm.gameManager.game.teams[1].cards.count.description)
                }
                .scoreTextStyle()
                .frame(width: 150, height: 150)
            }
        }
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
    let vm = RoundViewModel(gameManager: GameManager(game:DummyData.game0, cardManager: CardManager(context: DataManager.shared.context)), router: GameRouter())
    NavigationStack {
        RoundView(vm: vm)
        
    }
}
