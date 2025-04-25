//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import AVKit

class SoundManager{
   
   static let shared = SoundManager()
   
   var player: AVAudioPlayer?
   
   func playSound(fileName: String, fileExtension: String) {
      
      guard let errorSoundURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {return}
      
      do{
         player = try AVAudioPlayer(contentsOf: errorSoundURL)
         player?.play()
      }catch let error {
         print("Error Playing Sound. \(error.localizedDescription)")
      }
      
   }
}
