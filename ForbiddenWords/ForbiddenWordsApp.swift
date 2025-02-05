//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

@main
struct ForbiddenWordsApp: App {
   let container = try! ModelContainer(for: Game.self, Round.self, Team.self, Card.self)

    var body: some Scene {
        WindowGroup {
            ContentView()
              .modelContext(container.mainContext)
        }
    }
}
