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
            options: DummyData.cardCategory
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
                        .font(.title)
                    Spacer(minLength: 0)
                    
                    Image(systemName: state == .up ? "chevron.up" : "chevron.down")
                        .font(.title)
                        .foregroundColor(.orange)
                        .rotationEffect(.degrees((isShowing ? -180 : 0)))
                }
                .padding(.horizontal, 15)
                .frame(width: maxWidth, height: 50)
                .background(.black)
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
            .background(.black)
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
                        .foregroundStyle(.orange)
                        .font(.title)
                    Spacer()
                    Image(systemName: "checkmark")
                        .opacity(selection == option ? 1 : 0)
                }
                .foregroundStyle(selection == option ? Color.primary : Color.gray)
                .animation(.easeIn, value: selection)
                .frame(height: 40,alignment: .leading)
                .contentShape(.rect)
                .padding(.horizontal, 15)
                .onTapGesture {
                    withAnimation(.snappy) {
                        selection = option
                        isShowing.toggle()
                    }
                }
            }
        }
        .transition(.move(edge: state == .up ? .bottom : .top))
        .zIndex(1)
    }
}

#Preview{
    PickerView()
}
