//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.
import SwiftUI
@MainActor
struct CircularTimerView: View {
   @Binding var timeRemaining: Int
    @State private var timerRunning = false
   let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let totalDuration: TimeInterval = 60
    
    var body: some View {
        VStack{
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                Arc(endAngle: .degrees(Double(progress) * 360 - 90))
                    .stroke(Color.orange, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                
               Text("\(timeRemaining)")
                  .font(Font.custom("AttackOfMonsterRegular", size: 50))
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
