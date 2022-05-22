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
    
    init() {
        //let navBarAppearance = UINavigationBar.appearance()
                //navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.orange]
                    //navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.orange]
        //UINavigationBar.appearance().tintColor = .green
        //UIButton.appearance().backgroundColor = .green
        UINavigationBar.appearance().backgroundColor = UIColor(Color.backgroundColor)
        UITableView.appearance().backgroundColor = .clear
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}
