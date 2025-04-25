//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import Foundation
import SwiftUI

struct LogoView: View {
   var body: some View {
      VStack (spacing:1){
         Image("logo")
            .resizable()
            .scaledToFill()
      }
   }
}
#Preview{
   LogoView()
}

