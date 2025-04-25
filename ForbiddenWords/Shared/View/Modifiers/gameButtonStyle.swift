//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI


struct gameButtonStyle: ButtonStyle {
   var fillColor = Color.orange
   
   func makeBody(configuration: Configuration) -> some View {
      configuration.label
         .foregroundStyle(.white)
         .customFont(size: 15)
         .fontWeight(.bold)
         .padding()
         .shadow(color: .white, radius: 5)
         .background(
            RoundedRectangle(cornerRadius: 10)
               .fill(fillColor)
               .shadow(color: .white, radius: 1)
         )
         .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
         .opacity(configuration.isPressed ? 0.7 : 1.0)
         .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
   }
}
