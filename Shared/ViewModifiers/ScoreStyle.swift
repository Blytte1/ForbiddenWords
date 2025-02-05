//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI

struct ScoreStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center) // Alinha o texto ao centro
            .offset(y: 5)                   // Aplica um deslocamento vertical
            .foregroundStyle(.orange)        // Define a cor do texto como laranja
            .font(Font.custom("AttackOfMonsterRegular", size: 15))
    }
}

extension View {
    func scoreTextStyle() -> some View {
        self.modifier(ScoreStyle())
    }
}


