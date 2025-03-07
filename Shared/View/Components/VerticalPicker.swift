//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftUI

struct PickerView: View {
    
    @State var selection: String = "Objetos"
    
    var body: some View {
        Text("")
        VerticalPicker(
            selection: $selection,
            options: DummyData.defaultCardsDictionary.keys.map{$0}
        )
    }
}

enum VerticalPickerState {
    case up
    case down
}

struct VerticalPicker: View {
    
    @Binding var selection: String
    var state: VerticalPickerState = .down
    var options: [String]
    var maxWidth: CGFloat = 280
    
    @State var isShowing = false
    
    @SceneStorage("drop_down_zindex") private var index = 1000.0
    @State var zindex = 1000.0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            VStack(spacing: 0) {
                if state == .up && isShowing {
                    OptionsView()
                }
                HStack {
                    Text(selection)
                        .foregroundColor(.orange)
                        .bold()
                        .customFont(size: 30)
                        .minimumScaleFactor(0.5)
                    Spacer(minLength: 0)
                    Image(systemName: state == .up ? "chevron.up" : "chevron.down")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                        .rotationEffect(.degrees((isShowing ? -180 : 0)))
                        .bold()
                }
                .padding(.horizontal, 15)
                .frame(width: maxWidth, height: 50)
                .background(.white)
                .contentShape(.rect)
                .onTapGesture {
                    index += 1
                    zindex = index
                    withAnimation(.interpolatingSpring) {
                        isShowing.toggle()
                    }
                }
                .zIndex(10)
                if state == .down && isShowing {
                    OptionsView()
                }
            }
            .clipped()
            .background(.white)
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.orange,lineWidth:5)
            }
            .frame(width: maxWidth, height: size.height, alignment: state == .up ? .bottom : .top)
            
        }
        .frame(width: maxWidth, height: 50)
        .zIndex(zindex)
    }
    
    
    func OptionsView() -> some View {
        VStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                HStack {
                    Text(option)
                    Spacer()
                }
                .foregroundStyle(selection == option ? Color.white : Color.orange)
                .background(selection == option ? Color.orange : Color.white)
                .animation(.easeIn, value: selection)
                .frame(height: 40,alignment: .leading)
                .contentShape(Rectangle())
                .padding(.horizontal, 15)
                .onTapGesture {
                    withAnimation(.snappy) {
                        selection = option
                        isShowing.toggle()
                    }
                }
                .customFont(size: 30)
                .minimumScaleFactor(0.5)
            }
        }
        .transition(.move(edge: state == .up ? .bottom : .top))
        .zIndex(1)
    }
}

#Preview{
    PickerView()
}
