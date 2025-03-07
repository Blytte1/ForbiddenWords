//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI

struct ScoreStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .offset(y: 5)
            .foregroundStyle(.orange)
            .customFont(size: 25)
            .minimumScaleFactor(0.5)
    }
}

extension View {
    func scoreTextStyle() -> some View {
        self.modifier(ScoreStyle())
    }
}


