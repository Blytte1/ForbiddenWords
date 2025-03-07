//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import Foundation
import SwiftData

@Model class Card{
   
   @Attribute(.unique) var id: Int
   var keyWord: String
   var forbiddenWords: [String]
   var answerIsRight: Bool?
   var categories: [String] = []
   
   init(id: Int, keyWord: String, forbiddenWords: [String], categories: [String] = []) {
      self.id = id
      self.keyWord = keyWord
      self.forbiddenWords = forbiddenWords
      self.categories = categories
   }
   convenience init(original: Card) {
      self.init(
         id: original.id,
         keyWord: original.keyWord,
         forbiddenWords: original.forbiddenWords, // Creates a new array
         categories: original.categories          // Creates a new array
      )
      self.answerIsRight = original.answerIsRight // Optional, so direct assignment is fine.
   }
}


