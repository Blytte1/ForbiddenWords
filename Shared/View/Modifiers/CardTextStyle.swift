//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.
import SwiftUI

struct CardTextStyle: ViewModifier {
   var textColor: Color = .white
   func body(content: Content) -> some View {
      content
         .customFont(size: 30)
         .foregroundColor(textColor)
         .minimumScaleFactor(0.5)
         .frame(maxWidth: .infinity)
         .padding(.vertical)
   }
}


extension View {
   func cardTextStyle(textColor: Color = .white) -> some View {
      self.modifier(CardTextStyle(textColor: textColor))
   }
}
