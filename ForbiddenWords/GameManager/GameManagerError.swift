//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import Foundation

enum GameManagerError: Error {
   case gameNotInitialized
   case teamNotFound
   case cardNotFound
   case cardDealingFailed(underlyingError: Error)
}
