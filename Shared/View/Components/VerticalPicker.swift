//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftUI

struct PickerView: View {
   
   @State var selection: String = "Objetos"
   @State var selecao:String? = nil
   var body: some View {
      
      
      VerticalPicker(selection: $selection,options: DummyData.cardCategories)
      Spacer()
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
   @State var zindex = 100.0
   
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
                  .minimumScaleFactor(0.5) // Permite reduzir até 50%
               
               Spacer()
               
               Image(systemName: state == .up ? "chevron.up" : "chevron.down")
                  .font(.title)
                  .foregroundColor(.orange)
                  .rotationEffect(.degrees((isShowing ? -180 : 0)))
            }
            .padding(.horizontal, 15)
            .frame(width: maxWidth, height: 50)
            .background(.white)
            .contentShape(Rectangle())
            .onTapGesture {
               index += 1
               zindex = index
               withAnimation(.snappy) {
                  isShowing.toggle()
               }
            }
            .zIndex(10)
            
            if state == .down && isShowing {
               OptionsView()
            }
         }
         //.clipped()
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
                  .foregroundStyle(selection == option ? Color.white : Color.orange)
                  .font(.title)
               Spacer()
               Image(systemName: "checkmark")
                  .opacity(selection == option ? 1 : 0)
                  .bold()
            }
            .foregroundStyle(selection == option ? Color.white : Color.blue)
            .minimumScaleFactor(0.5)
            .background(selection == option ? Color.orange : .clear)
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
         }
      }
      .transition(.move(edge: state == .up ? .bottom : .top))
      .zIndex(1)
   }
}

#Preview("Pickerview1"){
   PickerView(selection: "Objetos")
}
