//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import AVKit

class SoundManager{
   
   static let shared = SoundManager()
   
   var player: AVAudioPlayer?
   
   static func playSound() {
      
      guard let errorSoundURL = URL(string: "") else { return }
      
      do{
         player = try AVAudioPlayer(contentsOf: errorSoundURL)
         player?.play()
      }catch let error {
         print("Error Playing Sound. \(error.localizedDescription)")
      }
      
   }
}
