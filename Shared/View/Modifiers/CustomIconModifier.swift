//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI

struct CustomIconModifier: ViewModifier {
    var size: CGFloat
    var color: Color
    var weight: Font.Weight

    func body(content: Content) -> some View {
        content
            .font(Font.system(size: size, weight: weight))
            .frame(width: size, height: size)
            .background(color)
            .cornerRadius(10)
            .foregroundColor(.orange)
            .scaledToFit()
    }
}

extension View {
    func customIconStyle(size: CGFloat = 40, color: Color = .red, weight: Font.Weight = .bold) -> some View {
        self.modifier(CustomIconModifier(size: size, color: color, weight: weight))
    }
}
