//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.
import SwiftUI

struct CustomGameFont: ViewModifier {
    let size: CGFloat

    func body(content: Content) -> some View {
        content.font(Font.custom("AttackOfMonsterRegular", size: size))
    }
}

extension View {
    func customFont(size: CGFloat) -> some View {
        self.modifier(CustomGameFont(size: size))
    }
}


