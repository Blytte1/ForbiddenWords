//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import Foundation

enum GameScreen:Hashable{
   case menu
   case team(Game)
   case turn(Game)
   case round(Game)
   case winner(Game)
   case gallery
}
