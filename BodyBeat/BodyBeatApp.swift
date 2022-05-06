//
//  BodyBeatApp.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 06.05.2022.
//

import SwiftUI

@main
struct BodyBeatApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
