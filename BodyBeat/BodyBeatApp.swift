//
//  BodyBeatApp.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 06.05.2022.
//

import SwiftUI
import Firebase

@main
struct BodyBeatApp: App {
    @StateObject var firestoreManager = FirestoreManager()
    
    let persistenceController = PersistenceController.shared
    
    init() {
        //let navBarAppearance = UINavigationBar.appearance()
                //navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.orange]
                    //navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.orange]
        //UINavigationBar.appearance().tintColor = .green
        //UIButton.appearance().backgroundColor = .green
        UINavigationBar.appearance().backgroundColor = UIColor(Color.backgroundColor)
        UITableView.appearance().backgroundColor = .clear
        
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(firestoreManager)
                .preferredColorScheme(.dark)
        }
    }
}
